# 曦光包装袋报价器 - Next.js + Supabase 云原生版

🎉 **现代云原生架构，完全告别本地花生壳！**

---

## 🚀 快速开始部署（只需5步）

### 第1步：注册 Supabase 账号
1. 访问 https://supabase.com/
2. 使用 GitHub 账号直接登录，完全免费
3. 创建一个新的 Project（项目名称随便取，比如 xiguang-packaging）
4. 等待约 2 分钟让项目初始化完成

### 第2步：配置数据库
1. 进入您刚创建的 Supabase Project 后台
2. 左侧菜单找到 **SQL Editor** 点击进入
3. 点击 **New query** 新建查询
4. 把 `supabase/migrations/001_init_schema.sql` 的全部代码粘贴进去
5. 点击 **RUN** 执行所有 SQL，数据库表自动创建完成！

### 第3步：获取项目密钥
1. 左侧菜单找到 **Project Settings** ⚙️ → **API**
2. 复制这两个关键信息：
   - `Project URL` (类似 https://xxx.supabase.co)
   - `anon public` 这串长长的密钥 (public)

### 第4步：推送到 GitHub
1. 在 GitHub.com 新建一个空的私有仓库
2. 把本项目代码推送到您的 GitHub 仓库

### 第5步：Vercel 一键上线
1. 访问 https://vercel.com/ 用 GitHub 账号直接登录
2. 点击 **Add New → Project**
3. 导入您刚推送代码的 GitHub 仓库
4. 在 Environment Variables 环境变量里填入：
   ```
   NEXT_PUBLIC_SUPABASE_URL=您刚才复制的Supabase Project URL
   NEXT_PUBLIC_SUPABASE_ANON_KEY=您刚才复制的anon密钥
   ```
5. 点击 **Deploy**！等待约1分钟，您的网站就全世界都可以访问了！

---

## 👤 创建第一个超级管理员账号
1. 在 Supabase 后台左侧找到 **Authentication → Users**
2. 点击 **Add user → Create new user**
3. 选择 **Email** 方式，填写：
   - Email: `13277205591@xiguang-packaging.local`
   - Password: `hdkdd520`
4. 创建成功后，在 Table Editor 里找到 profiles 表，把刚创建出来的这条记录的 `is_admin` 字段设置为 `true`
5. 完成！您现在就可以用手机号 13277205591 登录系统了！

---

## 📦 技术栈
- **Next.js 14** - React 全栈框架
- **TypeScript** - 类型安全
- **TailwindCSS** - 原子化样式
- **Supabase** - 开源 Firebase 替代，提供认证 + PostgreSQL 数据库 + 实时同步
- **Vercel** - 一键部署，全球 CDN 加速

---

## ✨ 核心特性
- 🔐 Supabase 原生安全认证，密码自动 bcrypt 加密
- 📊 PostgreSQL 企业级数据库，数据永不丢失
- ⚡ 全球实时同步，所有设备数据瞬间更新
- 🌐 自动 HTTPS，全球 CDN 访问极速
- 📈 零运维，完全不用自己维护服务器
