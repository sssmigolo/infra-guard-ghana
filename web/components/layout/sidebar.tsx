// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
'use client';

import { usePathname } from 'next/navigation';
import Link from 'next/link';

const navItems = [
    { icon: '🗺️', label: 'Overview', href: '/' },
    { icon: '⚡', label: 'Electricity', href: '/electricity' },
    { icon: '🛣️', label: 'Roads', href: '/roads' },
    { icon: '📋', label: 'Work Orders', href: '/work-orders' },
    { icon: '👥', label: 'Users', href: '/users' },
];

export function Sidebar() {
    const pathname = usePathname();

    return (
        <aside className="w-64 bg-surface-dark-card border-r border-surface-dark-border p-6 flex flex-col">
            {/* Logo */}
            <div className="flex items-center gap-3 mb-10">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-ghana-gold to-yellow-600 flex items-center justify-center">
                    <span className="text-xl">🛡️</span>
                </div>
                <div>
                    <h1 className="text-lg font-bold text-white">InfraGuard AI</h1>
                    <p className="text-xs text-gray-400">Admin Dashboard</p>
                </div>
            </div>

            {/* Navigation */}
            <nav className="flex-1 space-y-1">
                {navItems.map((item) => {
                    const isActive = pathname === item.href;
                    return (
                        <Link
                            key={item.href}
                            href={item.href}
                            className={isActive ? 'sidebar-item-active' : 'sidebar-item text-gray-400'}
                        >
                            <span className="text-lg">{item.icon}</span>
                            <span>{item.label}</span>
                        </Link>
                    );
                })}
            </nav>

            {/* Bottom */}
            <div className="mt-auto pt-6 border-t border-surface-dark-border">
                <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-full bg-ghana-gold/20 flex items-center justify-center text-ghana-gold font-bold text-sm">
                        AD
                    </div>
                    <div>
                        <p className="text-sm font-medium">Admin User</p>
                        <p className="text-xs text-gray-400">Government View</p>
                    </div>
                </div>
                <div className="flex items-center gap-1 mt-4">
                    <div className="h-1 w-4 bg-ghana-red rounded-full" />
                    <div className="h-1 w-4 bg-ghana-gold rounded-full" />
                    <div className="h-1 w-4 bg-ghana-green rounded-full" />
                    <span className="text-xs text-gray-500 ml-2">100% Free 🇬🇭</span>
                </div>
            </div>
        </aside>
    );
}
