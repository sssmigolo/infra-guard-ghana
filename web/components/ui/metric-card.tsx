// MIT License - Copyright (c) 2026 InfraGuard AI Contributors

interface MetricCardProps {
    title: string;
    value: string;
    trend: string;
    icon: string;
    color: string;
}

export function MetricCard({ title, value, trend, icon, color }: MetricCardProps) {
    const isPositive = !trend.startsWith('-') || title.includes('CO₂');
    return (
        <div className={`metric-card bg-gradient-to-br ${color}`}>
            <div className="flex items-center justify-between mb-3">
                <span className="text-2xl">{icon}</span>
                <span className={`text-sm font-semibold ${isPositive ? 'text-ghana-green' : 'text-ghana-red'}`}>{trend}</span>
            </div>
            <p className="text-3xl font-bold">{value}</p>
            <p className="text-sm text-gray-400 mt-1">{title}</p>
        </div>
    );
}
