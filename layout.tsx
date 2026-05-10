import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: '曦光包装袋报价器',
  description: '专业包装袋在线报价系统 - 快递袋、气泡袋、连卷袋智能报价',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="zh-CN">
      <body className="font-sans">
        {children}
      </body>
    </html>
  )
}
