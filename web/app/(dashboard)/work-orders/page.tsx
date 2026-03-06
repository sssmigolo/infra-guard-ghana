// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Work Orders Management Page

'use client';

const workOrders = [
    { id: 'WO-001', type: 'combined', priority: 'critical', title: 'Kaneshie Road Flood + Power Line Risk', location: 'Kaneshie, Accra', team: 'ECG + AMA Roads', score: 92, status: 'in_progress', due: '1 day' },
    { id: 'WO-002', type: 'electricity', priority: 'high', title: 'Osu Transformer Overhaul', location: 'Osu, Accra', team: 'ECG Maintenance', score: 78, status: 'scheduled', due: '7 days' },
    { id: 'WO-003', type: 'roads', priority: 'medium', title: 'N1 Pothole Repair', location: 'Accra-Tema Motorway', team: 'Unassigned', score: 65, status: 'open', due: '14 days' },
    { id: 'WO-004', type: 'electricity', priority: 'high', title: 'Tamale Pole Inspection', location: 'Tamale', team: 'ECG Northern', score: 72, status: 'scheduled', due: '5 days' },
    { id: 'WO-005', type: 'roads', priority: 'low', title: 'Cape Coast Pothole Patch', location: 'Cape Coast', team: 'Unassigned', score: 45, status: 'open', due: '30 days' },
];

export default function WorkOrdersPage() {
    return (
        <div className="space-y-8 animate-fade-in">
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-3xl font-bold">📋 Work Orders</h1>
                    <p className="text-gray-400 mt-1">Cross-module task management</p>
                </div>
                <button className="btn-ghana">+ Create Work Order</button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: 'Total Active', value: '5', color: 'text-ghana-gold' },
                    { label: 'Critical', value: '1', color: 'text-ghana-red' },
                    { label: 'Completed (Month)', value: '23', color: 'text-ghana-green' },
                    { label: 'Avg Resolution', value: '3.2 days', color: 'text-blue-400' },
                ].map((s) => (
                    <div key={s.label} className="glass-card p-5">
                        <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
                        <p className="text-sm text-gray-400 mt-1">{s.label}</p>
                    </div>
                ))}
            </div>

            {/* Work Orders Table */}
            <div className="glass-card p-6">
                <table className="w-full text-sm">
                    <thead>
                        <tr className="text-gray-400 border-b border-surface-dark-border">
                            <th className="text-left py-3">ID</th>
                            <th className="text-left py-3">Title</th>
                            <th className="text-center py-3">Type</th>
                            <th className="text-center py-3">Priority</th>
                            <th className="text-center py-3">Team</th>
                            <th className="text-center py-3">Urgency</th>
                            <th className="text-center py-3">Due</th>
                            <th className="text-center py-3">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {workOrders.map((wo) => (
                            <tr key={wo.id} className="table-row cursor-pointer">
                                <td className="py-3 font-mono text-ghana-gold">{wo.id}</td>
                                <td className="py-3">
                                    <p className="font-medium">{wo.title}</p>
                                    <p className="text-xs text-gray-400">{wo.location}</p>
                                </td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${wo.type === 'combined' ? 'bg-amber-500/15 text-amber-400' : wo.type === 'electricity' ? 'bg-ghana-gold/15 text-ghana-gold' : 'bg-ghana-green/15 text-ghana-green'}`}>
                                        {wo.type === 'electricity' ? '⚡' : wo.type === 'roads' ? '🛣️' : '🔀'} {wo.type}
                                    </span>
                                </td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${wo.priority === 'critical' ? 'bg-ghana-red/15 text-ghana-red' : wo.priority === 'high' ? 'bg-amber-500/15 text-amber-400' : wo.priority === 'medium' ? 'bg-ghana-gold/15 text-ghana-gold' : 'bg-gray-500/15 text-gray-400'}`}>
                                        {wo.priority}
                                    </span>
                                </td>
                                <td className="text-center py-3 text-gray-300">{wo.team}</td>
                                <td className="text-center py-3">
                                    <span className={`font-bold ${wo.score > 80 ? 'text-ghana-red' : wo.score > 60 ? 'text-amber-400' : 'text-ghana-green'}`}>{wo.score}%</span>
                                </td>
                                <td className="text-center py-3 text-gray-400">{wo.due}</td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${wo.status === 'in_progress' ? 'bg-blue-500/15 text-blue-400' : wo.status === 'scheduled' ? 'bg-ghana-gold/15 text-ghana-gold' : 'bg-gray-500/15 text-gray-400'}`}>
                                        {wo.status.replace('_', ' ')}
                                    </span>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
