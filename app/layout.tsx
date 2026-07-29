import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'GigOS — Local Gig Marketplace',
  description: 'AI-powered local gig marketplace for San Diego',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
