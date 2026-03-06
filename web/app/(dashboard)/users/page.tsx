// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - User Management Page

'use client';

const users = [
    { name: 'Kwame Asante', email: 'kwame@infraguard.gh', role: 'citizen', region: 'Greater Accra', reports: 12, status: 'active' },
    { name: 'Ama Serwaa', email: 'ama.s@ecg.com.gh', role: 'utility_engineer', region: 'Ashanti', reports: 45, status: 'active' },
    { name: 'Kofi Mensah', email: 'kofi.m@ama.gov.gh', role: 'municipal_officer', region: 'Greater Accra', reports: 28, status: 'active' },
    { name: 'Abena Osei', email: 'abena@fieldtech.gh', role: 'field_technician', region: 'Northern', reports: 67, status: 'active' },
    { name: 'Yaw Boateng', email: 'yaw@industry.gh', role: 'industrial_user', region: 'Western', reports: 8, status: 'active' },
    { name: 'Admin User', email: 'admin@infraguard.gh', role: 'admin', region: 'All Regions', reports: 0, status: 'active' },
];

const roleColors: Record<string, string> = {
    citizen: 'bg-gray-500/15 text-gray-300',
    field_technician: 'bg-blue-500/15 text-blue-400',
    utility_engineer: 'bg-ghana-gold/15 text-ghana-gold',
    municipal_officer: 'bg-purple-500/15 text-purple-400',
    industrial_user: 'bg-emerald-500/15 text-emerald-400',
    admin: 'bg-ghana-red/15 text-ghana-red',
};

export default function UsersPage() {
    return (
        <div className="space-y-8 animate-fade-in">
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-3xl font-bold">👥 User Management</h1>
                    <p className="text-gray-400 mt-1">Role-based access control</p>
                </div>
                <button className="btn-ghana">+ Invite User</button>
            </div>

            <div className="grid grid-cols-3 gap-4">
                {[
                    { label: 'Total Users', value: '2,847' },
                    { label: 'Active Today', value: '342' },
                    { label: 'Field Technicians', value: '56' },
                ].map((s) => (
                    <div key={s.label} className="glass-card p-5">
                        <p className="text-2xl font-bold text-ghana-gold">{s.value}</p>
                        <p className="text-sm text-gray-400 mt-1">{s.label}</p>
                    </div>
                ))}
            </div>

            <div className="glass-card p-6">
                <table className="w-full text-sm">
                    <thead>
                        <tr className="text-gray-400 border-b border-surface-dark-border">
                            <th className="text-left py-3">Name</th>
                            <th className="text-left py-3">Email</th>
                            <th className="text-center py-3">Role</th>
                            <th className="text-center py-3">Region</th>
                            <th className="text-center py-3">Reports</th>
                            <th className="text-center py-3">Status</th>
                            <th className="text-center py-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {users.map((u) => (
                            <tr key={u.email} className="table-row">
                                <td className="py-3 font-medium">{u.name}</td>
                                <td className="py-3 text-gray-400">{u.email}</td>
                                <td className="text-center py-3">
                                    <span className={`status-badge ${roleColors[u.role] || ''}`}>{u.role.replace('_', ' ')}</span>
                                </td>
                                <td className="text-center py-3">{u.region}</td>
                                <td className="text-center py-3 font-semibold">{u.reports}</td>
                                <td className="text-center py-3">
                                    <span className="status-badge bg-ghana-green/15 text-ghana-green">{u.status}</span>
                                </td>
                                <td className="text-center py-3">
                                    <button className="text-ghana-gold hover:underline text-xs">Edit</button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
