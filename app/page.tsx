'use client'

import { useState, useEffect } from 'react'
import { createClient } from '../lib/supabase/client'

export default function Home() {
  const [user, setUser] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [showLogin, setShowLogin] = useState(false)
  const [phone, setPhone] = useState('')
  const [password, setPassword] = useState('')
  const [loginError, setLoginError] = useState('')
  const [calculating, setCalculating] = useState(false)
  
  const supabase = createClient()

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser()
      setUser(user)
      setLoading(false)
    }
    getUser()

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })
    return () => subscription.unsubscribe()
  }, [supabase])

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoginError('')
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email: phone + '@xiguang-packaging.local',
        password: password,
      })
      if (error) throw error
      setShowLogin(false)
    } catch (err: any) {
      setLoginError(err.message || '登录失败')
    }
  }

  const handleLogout = async () => {
    await supabase.auth.signOut()
  }

  if (loading) return <div className="flex items-center justify-center min-h-screen">加载中...</div>

  return (
    <main className="max-w-4xl mx-auto p-6">
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-accent-500 mb-2">📦 曦光包装袋报价器</h1>
        <p className="text-lg text-gray-600">快递袋 · 气泡袋 · 连卷袋 智能报价系统</p>
      </div>

      {!user ? (
        <div className="bg-white rounded-2xl shadow-xl p-8 max-w-md mx-auto">
          {!showLogin ? (
            <div className="text-center">
              <p className="mb-6 text-gray-600">欢迎使用曦光报价系统</p>
              <button 
                onClick={() => setShowLogin(true)}
                className="w-full bg-accent-500 hover:bg-accent-600 text-white font-semibold py-3 rounded-xl transition-all"
              >
                登录系统
              </button>
            </div>
          ) : (
            <form onSubmit={handleLogin} className="space-y-4">
              <h2 className="text-2xl font-bold text-center text-accent-500">🔐 用户登录</h2>
              
              <div>
                <label className="block mb-2 font-medium text-center">手机号</label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="w-full border-2 border-accent-100 rounded-xl px-4 py-3 text-center focus:outline-none focus:border-accent-500"
                  placeholder="请输入手机号"
                  required
                />
              </div>

              <div>
                <label className="block mb-2 font-medium text-center">密码</label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full border-2 border-accent-100 rounded-xl px-4 py-3 text-center focus:outline-none focus:border-accent-500"
                  placeholder="请输入密码"
                  required
                />
              </div>

              {loginError && <p className="text-red-500 text-center font-medium">{loginError}</p>}

              <button type="submit" className="w-full bg-accent-500 hover:bg-accent-600 text-white font-semibold py-3 rounded-xl transition-all">
                登录
              </button>
            </form>
          )}
        </div>
      ) : (
        <div className="space-y-6">
          <div className="bg-white rounded-2xl shadow-lg p-6 flex justify-between items-center">
            <div>
              <p className="text-xl font-bold">👋 您好！欢迎使用曦光报价器</p>
              <p className="text-gray-500">已登录状态</p>
            </div>
            <button onClick={handleLogout} className="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-xl transition-all">
              退出登录
            </button>
          </div>

          <div className="bg-white rounded-2xl shadow-lg p-6">
            <h2 className="text-2xl font-bold text-accent-500 mb-4">🧮 报价计算器</h2>
            <p className="text-gray-500">核心报价功能即将上线...</p>
          </div>
        </div>
      )}
    </main>
  )
}
