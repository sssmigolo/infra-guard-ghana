// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Electricity Analytics Page

'use client';

import { XAxis, YAxis, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';

const outageHistory = [
    { week: 'W1', outages: 8, resolved: 7 }, { week: 'W2', outages: 5, resolved: 5 },
    { week: 'W3', outages: 12, resolved: 10 }, { week: 'W4', outages: 3, resolved: 3 },
    { week: 'W5', outages: 6, resolved: 6 }, { week: 'W6', outages: 4, resolved: 4 },
    { week: 'W7', outages: 9, resolved: 8 }, { week: 'W8', outages: 2, resolved: 2 },
];

const predictions = [
    { region: 'Kumasi Central', probability: 78, hours: 24, reason: 'Storm + aging transformer' },
    { region: 'Tamale Metropolis', probability: 62, hours: 48, reason: 'Harmattan dust on insulators' },
    { region: 'Cape Coast', probability: 55, hours: 72, reason: 'Scheduled maintenance nearby' },
    { region: 'East Legon, Accra', probability: 45, hours: 36, reason: 'Peak load expected' },
];

const transformers = [
    { name: 'Osu T-012', age: 12, risk: 82, status: 'Degraded', lastMaint: '90 days ago' },
    { name: 'Kumasi T-045', age: 8, risk: 68, status: 'Fair', lastMaint: '45 days ago' },
    { name: 'Tamale P-78', age: 15, risk: 72, status: 'Poor', lastMaint: '120 days ago' },
    { name: 'Achimota S-01', age: 5, risk: 35, status: 'Good', lastMaint: '15 days ago' },
];

export default function ElectricityPage() {
    return (
        <div className="space-y-8 animate-fade-in">
            <div>
                <h1 className="text-3xl font-bold flex items-center gap-3">⚡ Dumsor AI <span className="text-sm font-normal text-gray-400">Power Grid Intelligence</span></h1>
            </div>

            {/* KPIs */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: 'Active Outages', value: '1', color: 'text-ghana-red' },
                    { label: 'Predicted (72h)', value: '4', color: 'text-amber-400' },
                    { label: 'Grid Uptime', value: '97.2%', color: 'text-ghana-green' },
                    { label: 'Avg Resolution', value: '4.2h', color: 'text-ghana-gold' },
                ].map((kpi) => (
                    <div key={kpi.label} className="glass-card p-5">
                        <p className={`text-3xl font-bold ${kpi.color}`}>{kpi.value}</p>
                        <p className="text-sm text-gray-400 mt-1">{kpi.label}</p>
                    </div>
                ))}
            </div>

            {/* Outage History Chart */}
            <div className="glass-card p-6">
                <h3 className="text-lg font-semibold mb-4">Outage History (8 weeks)</h3>
                <ResponsiveContainer width="100%" height={250}>
                    <BarChart data={outageHistory}>
                        <XAxis dataKey="week" stroke="#64748B" fontSize={12} />
                        <YAxis stroke="#64748B" fontSize={12} />
                        <Tooltip contentStyle={{ background: '#141929', border: '1px solid #2A3050', borderRadius: 12 }} />
                        <Bar dataKey="outages" fill="#CE1126" radius={[4, 4, 0, 0]} name="Outages" />
                        <Bar dataKey="resolved" fill="#006B3F" radius={[4, 4, 0, 0]} name="Resolved" />
                    </BarChart>
                </ResponsiveContainer>
            </div>

            {/* AI Predictions */}
            <div className="glass-card p-6">
                <h3 className="text-lg font-semibold mb-4">AI Outage Predictions (24-72h)</h3>
                <div className="space-y-3">
                    {predictions.map((p) => (
                        <div key={p.region} className="flex items-center gap-4 p-4 rounded-xl bg-white/5">
                            <div className={`w-14 h-14 rounded-full flex items-center justify-center text-lg font-bold ${p.probability > 70 ? 'bg-ghana-red/15 text-ghana-red' : p.probability > 50 ? 'bg-amber-500/15 text-amber-400' : 'bg-ghana-gold/15 text-ghana-gold'}`}>
                                {p.probability}%
                            </div>
                            <div className="flex-1">
                                <p className="font-medium">{p.region}</p>
                                <p className="text-sm text-gray-400">{p.reason}</p>
                            </div>
                            <span className="text-sm text-gray-400">In {p.hours}h</span>
                            <button className="btn-ghana text-sm py-2 px-3">Alert</button>
                        </div>
                    ))}
                </div>
            </div>

            {/* Asset Health */}
            <div className="glass-card p-6">
                <h3 className="text-lg font-semibold mb-4">Transformer Health Monitor</h3>
                <table className="w-full text-sm">
                    <thead>
                        <tr className="text-gray-400 border-b border-surface-dark-border">
                            <th className="text-left py-3">Asset</th>
                            <th className="text-center py-3">Age (yrs)</th>
                            <th className="text-center py-3">Risk Score</th>
                            <th className="text-center py-3">Status</th>
                            <th className="text-center py-3">Last Maintenance</th>
                        </tr>
                    </thead>
                    <tbody>
                        {transformers.map((t) => (
                            <tr key={t.name} className="table-row">
                                <td className="py-3 font-medium">{t.name}</td>
                                <td className="text-center py-3">{t.age}</td>
                                <td className="text-center py-3">
                                    <span className={`font-bold ${t.risk > 70 ? 'text-ghana-red' : t.risk > 50 ? 'text-amber-400' : 'text-ghana-green'}`}>{t.risk}%</span>
                                </td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${t.status === 'Good' ? 'bg-ghana-green/15 text-ghana-green' : t.status === 'Degraded' ? 'bg-ghana-red/15 text-ghana-red' : 'bg-amber-500/15 text-amber-400'}`}>{t.status}</span>
                                </td>
                                <td className="text-center py-3 text-gray-400">{t.lastMaint}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
