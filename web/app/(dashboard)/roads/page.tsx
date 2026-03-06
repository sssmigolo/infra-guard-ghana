// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Roads Analytics Page

'use client';

import { PieChart, Pie, Cell, BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

const conditionData = [
    { name: 'Good', value: 45, color: '#34C759' },
    { name: 'Fair', value: 30, color: '#FFCC02' },
    { name: 'Poor', value: 18, color: '#FF3B30' },
    { name: 'Critical', value: 7, color: '#8B0000' },
];

const repairCosts = [
    { region: 'Accra', cost: 85000 },
    { region: 'Kumasi', cost: 52000 },
    { region: 'Tamale', cost: 38000 },
    { region: 'Cape Coast', cost: 24000 },
    { region: 'Volta', cost: 18000 },
];

const reports = [
    { id: 1, address: 'N1 Highway, Accra-Tema', type: 'Pothole', condition: 'Poor', cost: 2500, days: 30, confidence: 94, status: 'open' },
    { id: 2, address: 'Kumasi Ring Road', type: 'Crack', condition: 'Fair', cost: 1200, days: 60, confidence: 88, status: 'in_progress' },
    { id: 3, address: 'Kaneshie-Mallam Rd', type: 'Flooding', condition: 'Critical', cost: 15000, days: 7, confidence: 91, status: 'open' },
    { id: 4, address: 'Tamale-Bolga Highway', type: 'Erosion', condition: 'Poor', cost: 8000, days: 45, confidence: 85, status: 'open' },
    { id: 5, address: 'Cape Coast-Takoradi', type: 'Pothole', condition: 'Fair', cost: 3500, days: 90, confidence: 79, status: 'scheduled' },
];

export default function RoadsPage() {
    return (
        <div className="space-y-8 animate-fade-in">
            <div>
                <h1 className="text-3xl font-bold flex items-center gap-3">🛣️ Road CV AI <span className="text-sm font-normal text-gray-400">Computer Vision Intelligence</span></h1>
            </div>

            {/* KPIs */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: 'Open Reports', value: '12', color: 'text-ghana-red' },
                    { label: 'In Progress', value: '5', color: 'text-amber-400' },
                    { label: 'Fixed (Month)', value: '84', color: 'text-ghana-green' },
                    { label: 'Monitored', value: '340 km', color: 'text-ghana-gold' },
                ].map((kpi) => (
                    <div key={kpi.label} className="glass-card p-5">
                        <p className={`text-3xl font-bold ${kpi.color}`}>{kpi.value}</p>
                        <p className="text-sm text-gray-400 mt-1">{kpi.label}</p>
                    </div>
                ))}
            </div>

            <div className="grid grid-cols-2 gap-6">
                {/* Condition Distribution */}
                <div className="glass-card p-6">
                    <h3 className="text-lg font-semibold mb-4">Road Condition Distribution</h3>
                    <div className="flex items-center gap-8">
                        <ResponsiveContainer width={180} height={180}>
                            <PieChart>
                                <Pie data={conditionData} dataKey="value" cx="50%" cy="50%" outerRadius={80} innerRadius={50}>
                                    {conditionData.map((entry, i) => <Cell key={i} fill={entry.color} />)}
                                </Pie>
                            </PieChart>
                        </ResponsiveContainer>
                        <div className="space-y-3">
                            {conditionData.map((d) => (
                                <div key={d.name} className="flex items-center gap-3">
                                    <div className="w-3 h-3 rounded-full" style={{ background: d.color }} />
                                    <span className="text-sm">{d.name}</span>
                                    <span className="text-sm font-bold ml-auto">{d.value}%</span>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>

                {/* Repair Costs by Region */}
                <div className="glass-card p-6">
                    <h3 className="text-lg font-semibold mb-4">Est. Repair Costs by Region (GH₵)</h3>
                    <ResponsiveContainer width="100%" height={180}>
                        <BarChart data={repairCosts} layout="vertical">
                            <XAxis type="number" stroke="#64748B" fontSize={12} />
                            <YAxis dataKey="region" type="category" stroke="#64748B" fontSize={12} width={80} />
                            <Tooltip contentStyle={{ background: '#141929', border: '1px solid #2A3050', borderRadius: 12 }} />
                            <Bar dataKey="cost" fill="#006B3F" radius={[0, 6, 6, 0]} />
                        </BarChart>
                    </ResponsiveContainer>
                </div>
            </div>

            {/* Reports Table */}
            <div className="glass-card p-6">
                <h3 className="text-lg font-semibold mb-4">Road Reports</h3>
                <table className="w-full text-sm">
                    <thead>
                        <tr className="text-gray-400 border-b border-surface-dark-border">
                            <th className="text-left py-3">Location</th>
                            <th className="text-center py-3">Defect</th>
                            <th className="text-center py-3">Condition</th>
                            <th className="text-center py-3">Cost (GH₵)</th>
                            <th className="text-center py-3">TTF</th>
                            <th className="text-center py-3">AI %</th>
                            <th className="text-center py-3">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {reports.map((r) => (
                            <tr key={r.id} className="table-row">
                                <td className="py-3 font-medium">{r.address}</td>
                                <td className="text-center py-3">{r.type}</td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${r.condition === 'Critical' ? 'bg-red-900/30 text-red-400' : r.condition === 'Poor' ? 'bg-ghana-red/15 text-ghana-red' : 'bg-amber-500/15 text-amber-400'}`}>{r.condition}</span>
                                </td>
                                <td className="text-center py-3">{r.cost.toLocaleString()}</td>
                                <td className="text-center py-3">
                                    <span className={r.days <= 7 ? 'text-ghana-red font-bold' : r.days <= 30 ? 'text-amber-400' : 'text-gray-400'}>{r.days}d</span>
                                </td>
                                <td className="text-center py-3 font-semibold text-ghana-green">{r.confidence}%</td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${r.status === 'open' ? 'bg-ghana-red/15 text-ghana-red' : r.status === 'in_progress' ? 'bg-blue-500/15 text-blue-400' : 'bg-ghana-gold/15 text-ghana-gold'}`}>{r.status}</span>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
