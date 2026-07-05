import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "BlockGuard CLI",
  description: "Modern, lightweight, system-wide DNS ad-blocker & tracker protection.",
  base: '/BlockGuard/',
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Configuration', link: '/guide/configuration' },
      { text: 'License & Pricing', link: '/guide/pricing' },
      { text: 'Troubleshooting', link: '/guide/troubleshooting' }
    ],
    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'What is BlockGuard?', link: '/guide/what-is-blockguard' },
          { text: 'Comparison vs Free Tools', link: '/guide/comparison' },
          { text: 'Pricing & Trial', link: '/guide/pricing' }
        ]
      },
      {
        text: 'Getting Started',
        items: [
          { text: 'Installation', link: '/guide/getting-started' },
          { text: 'Quick Start (5 Min)', link: '/guide/quick-start' },
          { text: 'System-Wide Routing', link: '/guide/routing' }
        ]
      },
      {
        text: 'Features & Reference',
        items: [
          { text: 'Blocking Methods', link: '/guide/blocking-methods' },
          { text: 'Configuration Keys', link: '/guide/configuration' },
          { text: 'Filter List Management', link: '/guide/filters' },
          { text: 'Whitelisting Domains', link: '/guide/whitelist' }
        ]
      },
      {
        text: 'Maintenance',
        items: [
          { text: 'Troubleshooting', link: '/guide/troubleshooting' },
          { text: 'Uninstallation', link: '/guide/uninstall' }
        ]
      }
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/PrathxmOp/BlockGuard' }
    ],
    footer: {
      message: 'Released under Subscription Licensing.',
      copyright: 'Copyright © 2026-present PrathxmOp'
    }
  }
})
