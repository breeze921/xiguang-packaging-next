-- ==========================================
-- 曦光包装袋报价器 - Supabase 数据库初始化脚本
-- 直接复制到 Supabase SQL Editor 中执行即可
-- ==========================================

-- 启用 UUID 扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. 用户信息表 (扩展 auth.users)
-- ==========================================
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50) UNIQUE,
  nickname VARCHAR(255),
  name VARCHAR(255),
  company_name VARCHAR(500),
  is_admin BOOLEAN DEFAULT false,
  role VARCHAR(50) DEFAULT 'user',
  preferences JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- 2. RLS 策略 - Profiles 表
-- ==========================================
CREATE POLICY "用户可以查看自己的profile" 
  ON public.profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "用户可以更新自己的profile" 
  ON public.profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "管理员可以查看所有profiles" 
  ON public.profiles FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

CREATE POLICY "管理员可以更新所有profiles" 
  ON public.profiles FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

CREATE POLICY "管理员可以插入新profiles" 
  ON public.profiles FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

CREATE POLICY "管理员可以删除profiles" 
  ON public.profiles FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

-- ==========================================
-- 3. 自动创建 Profile 的触发器函数
-- ==========================================
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, phone, nickname, name, is_admin, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    SPLIT_PART(NEW.email, '@', 1), 
    SPLIT_PART(NEW.email, '@', 1), 
    SPLIT_PART(NEW.email, '@', 1), 
    false, 
    'user'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ==========================================
-- 4. 报价历史表
-- ==========================================
CREATE TABLE public.calculation_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  product_type VARCHAR(100),
  width DECIMAL(10,2),
  height DECIMAL(10,2),
  thickness DECIMAL(10,4),
  weight DECIMAL(10,2),
  price_per_kg DECIMAL(10,2),
  total_price DECIMAL(10,2),
  quantity INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.calculation_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "用户可以查看自己的计算历史" 
  ON public.calculation_history FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户可以创建自己的计算历史" 
  ON public.calculation_history FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户可以删除自己的计算历史" 
  ON public.calculation_history FOR DELETE USING (auth.uid() = user_id);

-- ==========================================
-- 5. 系统全局配置表
-- ==========================================
CREATE TABLE public.system_config (
  id SERIAL PRIMARY KEY,
  key VARCHAR(255) UNIQUE NOT NULL,
  value JSONB,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.system_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "所有人可以查看系统配置" ON public.system_config FOR SELECT USING (true);
CREATE POLICY "管理员可以修改系统配置" 
  ON public.system_config FOR ALL USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND is_admin = true)
  );

-- ==========================================
-- 6. 插入初始超级管理员占位
-- ==========================================
-- 提示：您后续直接在 Supabase Dashboard 的 Authentication 里手动创建第一个管理员账号即可！
