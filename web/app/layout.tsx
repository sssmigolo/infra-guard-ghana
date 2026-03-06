// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Root Layout

import type { Metadata } from 'next';
import { Sidebar } from '@/components/layout/sidebar';
import './globals.css';

export const metadata: Metadata = {
    title: 'InfraGuard AI – Ghana Infrastructure Dashboard',
    description: "Ghana's unified infrastructure intelligence platform. Monitor power grid, road conditions, and predict outages with AI. 100% free forever.",
    keywords: ['Ghana', 'infrastructure', 'AI', 'power grid', 'roads', 'Dumsor', 'ECG'],
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
    return (
        <html lang="en" className="dark">
            <head>
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
            </head>
            <body className="bg-surface-dark text-white font-outfit antialiased">
                <div className="flex min-h-screen">
                    <Sidebar />
                    <main className="flex-1 overflow-auto">
                        <div className="max-w-7xl mx-auto px-6 py-8">
                            {children}
                        </div>
                    </main>
                </div>
            </body>
        </html>
    );
}
