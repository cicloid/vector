use crate::{
    event::metric::{Metric, MetricValue, StatisticKind},
    sinks::util::{encode_namespace, statistic::DistributionStatistic},
};
use std::collections::BTreeMap;
use std::fmt::Write as _;

pub(super) trait MetricCollector {
    fn new() -> Self;

    fn emit(
        &mut self,
        timestamp: i64,
        name: &str,
        suffix: &str,
        value: f64,
        tags: &Option<BTreeMap<String, String>>,
        extra: Option<(&str, String)>,
    );

    fn encode_metric(
        &mut self,
        namespace: Option<&str>,
        buckets: &[f64],
        quantiles: &[f64],
        expired: bool,
        metric: &Metric,
    ) {
        let name = encode_namespace(namespace, '_', &metric.name);
        let name = &name;
        let timestamp = metric.timestamp.map(|t| t.timestamp()).unwrap_or(0);

        if metric.kind.is_absolute() {
            let tags = &metric.tags;

            match &metric.value {
                MetricValue::Counter { value } => {
                    self.emit(timestamp, &name, "", *value, tags, None);
                }
                MetricValue::Gauge { value } => {
                    self.emit(timestamp, &name, "", *value, tags, None);
                }
                MetricValue::Set { values } => {
                    // sets could expire
                    let value = if expired { 0 } else { values.len() };
                    self.emit(timestamp, &name, "", value as f64, tags, None);
                }
                MetricValue::Distribution {
                    values,
                    sample_rates,
                    statistic: StatisticKind::Histogram,
                } => {
                    // convert distributions into aggregated histograms
                    let mut counts = vec![0; buckets.len()];
                    let mut sum = 0.0;
                    let mut count = 0;
                    for (v, c) in values.iter().zip(sample_rates.iter()) {
                        buckets
                            .iter()
                            .enumerate()
                            .skip_while(|&(_, b)| b < v)
                            .for_each(|(i, _)| {
                                counts[i] += c;
                            });

                        sum += v * (*c as f64);
                        count += c;
                    }

                    for (b, c) in buckets.iter().zip(counts.iter()) {
                        self.emit(
                            timestamp,
                            &name,
                            "_bucket",
                            *c as f64,
                            tags,
                            Some(("le", b.to_string())),
                        );
                    }
                    self.emit(
                        timestamp,
                        &name,
                        "_bucket",
                        count as f64,
                        tags,
                        Some(("le", "+Inf".to_string())),
                    );
                    self.emit(timestamp, &name, "_sum", sum as f64, tags, None);
                    self.emit(timestamp, &name, "_count", count as f64, tags, None);
                }
                MetricValue::Distribution {
                    values,
                    sample_rates,
                    statistic: StatisticKind::Summary,
                } => {
                    if let Some(statistic) =
                        DistributionStatistic::new(values, sample_rates, quantiles)
                    {
                        for (q, v) in statistic.quantiles.iter() {
                            self.emit(
                                timestamp,
                                &name,
                                "",
                                *v,
                                tags,
                                Some(("quantile", q.to_string())),
                            );
                        }
                        self.emit(timestamp, &name, "_sum", statistic.sum, tags, None);
                        self.emit(
                            timestamp,
                            &name,
                            "_count",
                            statistic.count as f64,
                            tags,
                            None,
                        );
                        self.emit(timestamp, &name, "_min", statistic.min, tags, None);
                        self.emit(timestamp, &name, "_max", statistic.max, tags, None);
                        self.emit(timestamp, &name, "_avg", statistic.avg, tags, None);
                    } else {
                        self.emit(timestamp, &name, "_sum", 0.0, tags, None);
                        self.emit(timestamp, &name, "_count", 0.0, tags, None);
                    }
                }
                MetricValue::AggregatedHistogram {
                    buckets,
                    counts,
                    count,
                    sum,
                } => {
                    for (b, c) in buckets.iter().zip(counts.iter()) {
                        self.emit(
                            timestamp,
                            &name,
                            "_bucket",
                            *c as f64,
                            tags,
                            Some(("le", b.to_string())),
                        );
                    }
                    self.emit(
                        timestamp,
                        &name,
                        "_bucket",
                        *count as f64,
                        tags,
                        Some(("le", "+Inf".to_string())),
                    );
                    self.emit(timestamp, &name, "_sum", *sum, tags, None);
                    self.emit(timestamp, &name, "_count", *count as f64, tags, None);
                }
                MetricValue::AggregatedSummary {
                    quantiles,
                    values,
                    count,
                    sum,
                } => {
                    for (q, v) in quantiles.iter().zip(values.iter()) {
                        self.emit(
                            timestamp,
                            &name,
                            "",
                            *v,
                            tags,
                            Some(("quantile", q.to_string())),
                        );
                    }
                    self.emit(timestamp, &name, "_sum", *sum, tags, None);
                    self.emit(timestamp, &name, "_count", *count as f64, tags, None);
                }
            }
        }
    }
}

pub(super) struct StringCollector {
    pub result: String,
}

impl MetricCollector for StringCollector {
    fn new() -> Self {
        let result = String::new();
        Self { result }
    }

    fn emit(
        &mut self,
        _timestamp: i64,
        name: &str,
        suffix: &str,
        value: f64,
        tags: &Option<BTreeMap<String, String>>,
        extra: Option<(&str, String)>,
    ) {
        self.result.push_str(name);
        self.result.push_str(suffix);
        self.encode_tags(tags, extra);
        writeln!(&mut self.result, " {}", value).ok();
    }
}

impl StringCollector {
    fn encode_tags(
        &mut self,
        tags: &Option<BTreeMap<String, String>>,
        extra: Option<(&str, String)>,
    ) {
        match (tags, extra) {
            (None, None) => Ok(()),
            (None, Some(tag)) => write!(&mut self.result, "{{{}=\"{}\"}}", tag.0, tag.1),
            (Some(tags), ref tag) => {
                let mut parts = tags
                    .iter()
                    .map(|(name, value)| format!("{}=\"{}\"", name, value))
                    .collect::<Vec<_>>();

                if let Some(tag) = tag {
                    parts.push(format!("{}=\"{}\"", tag.0, tag.1));
                }

                parts.sort();
                write!(&mut self.result, "{{{}}}", parts.join(","))
            }
        }
        .ok();
    }

    pub(super) fn encode_header(&mut self, namespace: Option<&str>, metric: &Metric) {
        let name = &metric.name;
        let fullname = encode_namespace(namespace, '_', name);

        let r#type = match &metric.value {
            MetricValue::Counter { .. } => "counter",
            MetricValue::Gauge { .. } => "gauge",
            MetricValue::Distribution {
                statistic: StatisticKind::Histogram,
                ..
            } => "histogram",
            MetricValue::Distribution {
                statistic: StatisticKind::Summary,
                ..
            } => "summary",
            MetricValue::Set { .. } => "gauge",
            MetricValue::AggregatedHistogram { .. } => "histogram",
            MetricValue::AggregatedSummary { .. } => "summary",
        };

        writeln!(&mut self.result, "# HELP {} {}", fullname, name).ok();
        writeln!(&mut self.result, "# TYPE {} {}", fullname, r#type).ok();
    }
}

#[cfg(test)]
mod tests {
    use super::super::default_summary_quantiles;
    use super::*;
    use crate::event::metric::{Metric, MetricKind, MetricValue, StatisticKind};
    use pretty_assertions::assert_eq;

    fn encode_metric_header(namespace: Option<&str>, metric: &Metric) -> String {
        let mut s = StringCollector::new();
        s.encode_header(namespace, metric);
        s.result
    }

    fn encode_metric_datum(
        namespace: Option<&str>,
        buckets: &[f64],
        quantiles: &[f64],
        expired: bool,
        metric: &Metric,
    ) -> String {
        let mut s = StringCollector::new();
        s.encode_metric(namespace, buckets, quantiles, expired, metric);
        s.result
    }

    fn tags() -> BTreeMap<String, String> {
        vec![("code".to_owned(), "200".to_owned())]
            .into_iter()
            .collect()
    }

    #[test]
    fn test_encode_counter() {
        let metric = Metric {
            name: "hits".to_owned(),
            namespace: None,
            timestamp: None,
            tags: Some(tags()),
            kind: MetricKind::Absolute,
            value: MetricValue::Counter { value: 10.0 },
        };

        let header = encode_metric_header(Some("vector"), &metric);
        let frame = encode_metric_datum(Some("vector"), &[], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP vector_hits hits\n# TYPE vector_hits counter\n".to_owned()
        );
        assert_eq!(frame, "vector_hits{code=\"200\"} 10\n".to_owned());
    }

    #[test]
    fn test_encode_gauge() {
        let metric = Metric {
            name: "temperature".to_owned(),
            namespace: None,
            timestamp: None,
            tags: Some(tags()),
            kind: MetricKind::Absolute,
            value: MetricValue::Gauge { value: -1.1 },
        };

        let header = encode_metric_header(Some("vector"), &metric);
        let frame = encode_metric_datum(Some("vector"), &[], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP vector_temperature temperature\n# TYPE vector_temperature gauge\n".to_owned()
        );
        assert_eq!(frame, "vector_temperature{code=\"200\"} -1.1\n".to_owned());
    }

    #[test]
    fn test_encode_set() {
        let metric = Metric {
            name: "users".to_owned(),
            namespace: None,
            timestamp: None,
            tags: None,
            kind: MetricKind::Absolute,
            value: MetricValue::Set {
                values: vec!["foo".into()].into_iter().collect(),
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP users users\n# TYPE users gauge\n".to_owned()
        );
        assert_eq!(frame, "users 1\n".to_owned());
    }

    #[test]
    fn test_encode_expired_set() {
        let metric = Metric {
            name: "users".to_owned(),
            namespace: None,
            timestamp: None,
            tags: None,
            kind: MetricKind::Absolute,
            value: MetricValue::Set {
                values: vec!["foo".into()].into_iter().collect(),
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[], &[], true, &metric);

        assert_eq!(
            header,
            "# HELP users users\n# TYPE users gauge\n".to_owned()
        );
        assert_eq!(frame, "users 0\n".to_owned());
    }

    #[test]
    fn test_encode_distribution() {
        let metric = Metric {
            name: "requests".to_owned(),
            namespace: None,
            timestamp: None,
            tags: None,
            kind: MetricKind::Absolute,
            value: MetricValue::Distribution {
                values: vec![1.0, 2.0, 3.0],
                sample_rates: vec![3, 3, 2],
                statistic: StatisticKind::Histogram,
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[0.0, 2.5, 5.0], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP requests requests\n# TYPE requests histogram\n".to_owned()
        );
        assert_eq!(frame, "requests_bucket{le=\"0\"} 0\nrequests_bucket{le=\"2.5\"} 6\nrequests_bucket{le=\"5\"} 8\nrequests_bucket{le=\"+Inf\"} 8\nrequests_sum 15\nrequests_count 8\n".to_owned());
    }

    #[test]
    fn test_encode_histogram() {
        let metric = Metric {
            name: "requests".to_owned(),
            namespace: None,
            timestamp: None,
            tags: None,
            kind: MetricKind::Absolute,
            value: MetricValue::AggregatedHistogram {
                buckets: vec![1.0, 2.1, 3.0],
                counts: vec![1, 2, 3],
                count: 6,
                sum: 12.5,
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP requests requests\n# TYPE requests histogram\n".to_owned()
        );
        assert_eq!(frame, "requests_bucket{le=\"1\"} 1\nrequests_bucket{le=\"2.1\"} 2\nrequests_bucket{le=\"3\"} 3\nrequests_bucket{le=\"+Inf\"} 6\nrequests_sum 12.5\nrequests_count 6\n".to_owned());
    }

    #[test]
    fn test_encode_summary() {
        let metric = Metric {
            name: "requests".to_owned(),
            namespace: None,
            timestamp: None,
            tags: Some(tags()),
            kind: MetricKind::Absolute,
            value: MetricValue::AggregatedSummary {
                quantiles: vec![0.01, 0.5, 0.99],
                values: vec![1.5, 2.0, 3.0],
                count: 6,
                sum: 12.0,
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[], &[], false, &metric);

        assert_eq!(
            header,
            "# HELP requests requests\n# TYPE requests summary\n".to_owned()
        );
        assert_eq!(frame, "requests{code=\"200\",quantile=\"0.01\"} 1.5\nrequests{code=\"200\",quantile=\"0.5\"} 2\nrequests{code=\"200\",quantile=\"0.99\"} 3\nrequests_sum{code=\"200\"} 12\nrequests_count{code=\"200\"} 6\n".to_owned());
    }

    #[test]
    fn test_encode_distribution_summary() {
        let metric = Metric {
            name: "requests".to_owned(),
            namespace: None,
            timestamp: None,
            tags: Some(tags()),
            kind: MetricKind::Absolute,
            value: MetricValue::Distribution {
                values: vec![1.0, 2.0, 3.0],
                sample_rates: vec![3, 3, 2],
                statistic: StatisticKind::Summary,
            },
        };

        let header = encode_metric_header(None, &metric);
        let frame = encode_metric_datum(None, &[], &default_summary_quantiles(), false, &metric);

        assert_eq!(
            header,
            "# HELP requests requests\n# TYPE requests summary\n".to_owned()
        );
        assert_eq!(frame, "requests{code=\"200\",quantile=\"0.5\"} 2\nrequests{code=\"200\",quantile=\"0.75\"} 2\nrequests{code=\"200\",quantile=\"0.9\"} 3\nrequests{code=\"200\",quantile=\"0.95\"} 3\nrequests{code=\"200\",quantile=\"0.99\"} 3\nrequests_sum{code=\"200\"} 15\nrequests_count{code=\"200\"} 8\nrequests_min{code=\"200\"} 1\nrequests_max{code=\"200\"} 3\nrequests_avg{code=\"200\"} 1.875\n".to_owned());
    }
}
