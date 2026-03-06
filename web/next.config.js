/** @type {import('next').NextConfig} */
// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
const nextConfig = {
    reactStrictMode: true,
    outputFileTracingRoot: __dirname,
    images: {
        domains: ['images.unsplash.com', 'your-supabase-project.supabase.co'],
    },
    typescript: {
        ignoreBuildErrors: true,
    },
    eslint: {
        ignoreDuringBuilds: true,
    },
};

module.exports = nextConfig;
