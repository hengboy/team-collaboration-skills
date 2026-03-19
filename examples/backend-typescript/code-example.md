# Backend Skill - 代码输出示例

## 输入

API: .collaboration/features/mobile-login/api.yaml
技术方案：.collaboration/features/mobile-login/tech.md

## AI 输出示例

### src/auth/auth.controller.ts

```typescript
import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto.phone, dto.code);
  }
}
```

### src/auth/auth.service.ts

```typescript
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(private readonly jwtService: JwtService) {}

  async login(phone: string, code: string) {
    const token = this.jwtService.sign({ phone });
    return { token, user: { phone } };
  }
}
```

## 质量检查清单

- [ ] 代码清晰，命名准确
- [ ] 错误处理完善
- [ ] 日志记录充分
- [ ] 测试覆盖完整
- [ ] 已执行代码质量检查（如 lint / Biome / format check）
- [ ] 已执行语法、类型与构建检查（如 typecheck / tsc / build）
- [ ] 已执行单元、集成、契约或启动 smoke 检查
- [ ] 已检查 DTO 校验、鉴权、异常映射、查询与响应格式
