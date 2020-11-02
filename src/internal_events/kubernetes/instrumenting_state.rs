use super::InternalEvent;
use metrics::counter;
use std::fmt::Debug;

#[derive(Debug)]
pub struct StateItemAdded;

#[derive(Debug)]
pub struct StateItemUpdated;

#[derive(Debug)]
pub struct StateItemDeleted;

#[derive(Debug)]
pub struct StateResynced;

#[derive(Debug)]
pub struct StateMaintenanceRequested;

#[derive(Debug)]
pub struct StateMaintenancePerformed;

enum OpKind {
    ItemAdded,
    ItemDeleted,
    ItemUpdated,
    MaintenancePerformed,
    MaintenanceRequested,
    Resynced,
}

impl OpKind {
    fn to_str(&self) -> &str {
        OpKind::ItemAdded => "item_added",
        OpKind::ItemDeleted => "item_deleted",
        OpKind::ItemUpdated => "item_updated",
        OpKind::MaintenancePerformed => "maintenance_performed",
        OpKind::MaintenanceRequested => "maintenance_requested",
        OpKind::Resynced => "resynced",
    }
}

impl InternalEvent for StateItemAdded {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::ItemAdded.to_str());
    }
}

impl InternalEvent for StateItemUpdated {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::ItemUpdated.to_str());
    }
}

impl InternalEvent for StateItemDeleted {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::ItemDeleted.to_str());
    }
}

impl InternalEvent for StateResynced {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::Resynced.to_str());
    }
}

impl InternalEvent for StateMaintenanceRequested {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::MaintenanceRequested.to_str());
    }
}

impl InternalEvent for StateMaintenancePerformed {
    fn emit_metrics(&self) {
        counter!("k8s_state_ops_total", 1, "op_kind" => OpKind::MaintenancePerformed.to_str());
    }
}
