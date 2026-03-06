// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Dashboard Overview Page

'use client';

import { AreaChart, Area, BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
import { MetricCard } from '@/components/ui/metric-card';

const uptimeData = [
    { month: 'Sep', uptime: 94.1 }, { month: 'Oct', uptime: 94.8 },
    { month: 'Nov', uptime: 95.5 }, { month: 'Dec', uptime: 96.1 },
    { month: 'Jan', uptime: 96.8 }, { month: 'Feb', uptime: 97.2 },
];

const roadData = [
    { month: 'Sep', fixed: 18 }, { month: 'Oct', fixed: 24 },
    { month: 'Nov', fixed: 31 }, { month: 'Dec', fixed: 28 },
    { month: 'Jan', fixed: 35 }, { month: 'Feb', fixed: 42 },
];

const alerts = [
    { id: 1, type: 'COMBINED', title: 'Kaneshie road flood → power line risk', score: 92, status: 'active' },
    { id: 2, type: 'POWER', title: 'Osu transformer overload predicted', score: 87, status: 'active' },
    { id: 3, type: 'ROAD', title: 'N1 Highway pothole critical (30 days)', score: 71, status: 'open' },
];

export default function DashboardPage() {
    return (
        <div className="space-y-8 animate-fade-in">
            {/* Header */}
            <div>
                <h1 className="text-3xl font-bold">Dashboard Overview</h1>
                <p className="text-gray-400 mt-1">Real-time Ghana infrastructure intelligence</p>
            </div>

            {/* KPI Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <MetricCard title="Grid Uptime" value="97.2%" trend="+2.1%" icon="⚡" color="from-ghana-gold/20 to-ghana-gold/5" />
                <MetricCard title="Active Outages" value="1" trend="-67%" icon="🔴" color="from-ghana-red/20 to-ghana-red/5" />
                <MetricCard title="Roads Fixed" value="142 km" trend="+18%" icon="🛣️" color="from-ghana-green/20 to-ghana-green/5" />
                <MetricCard title="CO₂ Saved" value="4.2 tonnes" trend="-15%" icon="🌱" color="from-green-500/20 to-green-500/5" />
            </div>

            {/* Charts */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <div className="glass-card p-6">
                    <h3 className="text-lg font-semibold mb-4">Grid Uptime Trend</h3>
                    <ResponsiveContainer width="100%" height={220}>
                        <AreaChart data={uptimeData}>
                            <defs>
                                <linearGradient id="goldGradient" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="5%" stopColor="#FCD116" stopOpacity={0.3} />
                                    <stop offset="95%" stopColor="#FCD116" stopOpacity={0} />
                                </linearGradient>
                            </defs>
                            <XAxis dataKey="month" stroke="#64748B" fontSize={12} />
                            <YAxis domain={[93, 98]} stroke="#64748B" fontSize={12} />
                            <Tooltip contentStyle={{ background: '#141929', border: '1px solid #2A3050', borderRadius: 12 }} />
                            <Area type="monotone" dataKey="uptime" stroke="#FCD116" strokeWidth={2} fill="url(#goldGradient)" />
                        </AreaChart>
                    </ResponsiveContainer>
                </div>

                <div className="glass-card p-6">
                    <h3 className="text-lg font-semibold mb-4">Roads Repaired (km/month)</h3>
                    <ResponsiveContainer width="100%" height={220}>
                        <BarChart data={roadData}>
                            <XAxis dataKey="month" stroke="#64748B" fontSize={12} />
                            <YAxis stroke="#64748B" fontSize={12} />
                            <Tooltip contentStyle={{ background: '#141929', border: '1px solid #2A3050', borderRadius: 12 }} />
                            <Bar dataKey="fixed" fill="#006B3F" radius={[6, 6, 0, 0]} />
                        </BarChart>
                    </ResponsiveContainer>
                </div>
            </div>

            {/* Active Alerts */}
            <div className="glass-card p-6">
                <div className="flex items-center justify-between mb-4">
                    <h3 className="text-lg font-semibold">AI Cross-Module Alerts</h3>
                    <span className="status-badge bg-ghana-red/15 text-ghana-red">{alerts.filter(a => a.status === 'active').length} Active</span>
                </div>
                <div className="space-y-3">
                    {alerts.map((alert) => (
                        <div key={alert.id} className="flex items-center gap-4 p-4 rounded-xl bg-white/5 hover:bg-white/10 transition-colors">
                            <div className={`w-12 h-12 rounded-full flex items-center justify-center text-sm font-bold ${alert.score > 80 ? 'bg-ghana-red/15 text-ghana-red' : 'bg-ghana-gold/15 text-ghana-gold'}`}>
                                {alert.score}%
                            </div>
                            <div className="flex-1">
                                <p className="font-medium">{alert.title}</p>
                                <span className={`status-badge mt-1 ${alert.type === 'COMBINED' ? 'bg-amber-500/15 text-amber-400' : alert.type === 'POWER' ? 'bg-ghana-gold/15 text-ghana-gold' : 'bg-ghana-green/15 text-ghana-green'}`}>
                                    {alert.type}
                                </span>
                            </div>
                            <button className="btn-ghana text-sm py-2 px-4">View</button>
                        </div>
                    ))}
                </div>
            </div>

            {/* Regional Overview */}
            <div className="glass-card p-6">
                <h3 className="text-lg font-semibold mb-4">Regional Overview</h3>
                <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                        <thead>
                            <tr className="text-gray-400 border-b border-surface-dark-border">
                                <th className="text-left py-3 font-medium">Region</th>
                                <th className="text-center py-3 font-medium">Outages (30d)</th>
                                <th className="text-center py-3 font-medium">Roads Fixed</th>
                                <th className="text-center py-3 font-medium">Health Score</th>
                                <th className="text-center py-3 font-medium">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            {[
                                { r: 'Greater Accra', o: 12, rf: 45, s: 78, st: 'Moderate' },
                                { r: 'Ashanti', o: 8, rf: 32, s: 82, st: 'Good' },
                                { r: 'Northern', o: 15, rf: 28, s: 65, st: 'At Risk' },
                                { r: 'Western', o: 6, rf: 22, s: 88, st: 'Good' },
                                { r: 'Volta', o: 9, rf: 18, s: 74, st: 'Moderate' },
                            ].map((row) => (
                                <tr key={row.r} className="table-row">
                                    <td className="py-3 font-medium">{row.r}</td>
                                    <td className="text-center py-3">{row.o}</td>
                                    <td className="text-center py-3">{row.rf}</td>
                                    <td className="text-center py-3">
                                        <span className={`font-semibold ${row.s >= 80 ? 'text-ghana-green' : row.s >= 70 ? 'text-ghana-gold' : 'text-ghana-red'}`}>{row.s}%</span>
                                    </td>
                                    <td className="text-center py-3">
                                        <span className={`status-badge ${row.st === 'Good' ? 'bg-ghana-green/15 text-ghana-green' : row.st === 'At Risk' ? 'bg-ghana-red/15 text-ghana-red' : 'bg-ghana-gold/15 text-ghana-gold'}`}>{row.st}</span>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
