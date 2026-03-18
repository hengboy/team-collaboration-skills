# Frontend Skill - 代码输出示例

## 输入

API: docs/api/auth.yaml
设计稿：登录页面

## AI 输出示例

### src/pages/login/LoginPage.tsx

```typescript
import React, { useState } from 'react';

export const LoginPage: React.FC = () => {
  const [phone, setPhone] = useState('');
  const [code, setCode] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    // 登录逻辑
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={phone} onChange={(e) => setPhone(e.target.value)} />
      <input value={code} onChange={(e) => setCode(e.target.value)} />
      <button type="submit">登录</button>
    </form>
  );
};
```

## 质量检查清单

- [ ] 组件职责单一
- [ ] Props 类型完整
- [ ] 加载/错误状态处理
