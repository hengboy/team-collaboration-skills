# Backend Engineer Skill - OpenCode 使用示例

## 场景：手机号登录 API 实现

### 前置准备

```bash
# 1. 进入项目目录
cd /path/to/project

# 2. 打包上下文（包含 API 契约、技术方案）
./tools/context-pack.sh backend 手机号登录

# 3. 启动 OpenCode
opencode
```

### 步骤 1：加载 Skill

在 OpenCode 对话中：

```
skill(name: backend-engineer)
```

OpenCode 会加载 Backend Engineer Skill。

### 步骤 2：实现 API

```
请根据 API 契约实现手机号登录接口。

## API 契约

@docs/api/auth.yaml

## 技术方案

@docs/tech/mobile-login.md

## 技术栈

- 语言：TypeScript
- 框架：NestJS
- ORM：TypeORM
- 测试：Jest
- 缓存：Redis

## 任务

1. 实现 AuthController（发送验证码、登录接口）
2. 实现 AuthService（业务逻辑）
3. 实现必要的 DTO（输入验证）
4. 添加错误处理和日志记录
5. 编写单元测试

## 输出要求

- 遵循 NestJS 最佳实践（Controller/Service/Repository 分层）
- 统一响应格式：{ code, data, message }
- 包含完整类型定义
```

### 步骤 3：AI 生成代码

AI 会生成以下文件：

#### src/auth/auth.controller.ts

```typescript
import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { SendCodeDto } from './dto/send-code.dto';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('send-code')
  @HttpCode(HttpStatus.OK)
  async sendCode(@Body() sendCodeDto: SendCodeDto) {
    try {
      await this.authService.sendCode(sendCodeDto.phone);
      return {
        code: 0,
        message: '发送成功',
        data: {
          expireInSeconds: 300,
          retryAfterSeconds: 60,
        },
      };
    } catch (error) {
      throw new BadRequestException({
        code: 400,
        message: error.message,
      });
    }
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto) {
    try {
      const result = await this.authService.login(
        loginDto.phone,
        loginDto.code,
        loginDto.remember,
      );
      return {
        code: 0,
        message: '登录成功',
        data: result,
      };
    } catch (error) {
      throw new BadRequestException({
        code: error.code || 400,
        message: error.message,
      });
    }
  }
}
```

#### src/auth/auth.service.ts

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/user.entity';
import { SmsService } from '../sms/sms.service';
import { RedisService } from '../redis/redis.service';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly smsService: SmsService,
    private readonly redisService: RedisService,
    private readonly jwtService: JwtService,
  ) {}

  async sendCode(phone: string): Promise<void> {
    try {
      // 生成 6 位验证码
      const code = Math.floor(100000 + Math.random() * 900000).toString();
      
      // 发送短信
      await this.smsService.send(phone, code);
      
      // 存储验证码到 Redis（5 分钟有效期）
      await this.redisService.set(`code:${phone}`, code, 300);
      
      this.logger.log(`验证码已发送到 ${phone}`);
    } catch (error) {
      this.logger.error('发送验证码失败', error);
      throw new Error('服务暂时不可用');
    }
  }

  async login(
    phone: string,
    code: string,
    remember = false,
  ): Promise<{ token: string; user: User }> {
    // 验证验证码
    const storedCode = await this.redisService.get(`code:${phone}`);
    if (!storedCode) {
      throw new Error('验证码已过期');
    }
    
    if (storedCode !== code) {
      throw new Error('验证码错误');
    }
    
    // 查找或创建用户
    let user = await this.userRepository.findOne({ where: { phone } });
    if (!user) {
      user = await this.userRepository.save({ phone });
    }
    
    // 生成 Token
    const expiresIn = remember ? '7d' : '1d';
    const token = this.jwtService.sign({ sub: user.id, phone: user.phone });
    
    // 删除验证码
    await this.redisService.del(`code:${phone}`);
    
    this.logger.log(`用户登录：${phone}`);
    
    return { token, user };
  }
}
```

#### src/auth/dto/login.dto.ts

```typescript
import { IsString, IsPhoneNumber, IsBoolean, IsOptional, Length, Matches } from 'class-validator';

export class LoginDto {
  @IsString()
  @IsPhoneNumber('CN', { message: '请输入正确的手机号' })
  phone: string;

  @IsString()
  @Length(6, 6, { message: '验证码必须是 6 位数字' })
  @Matches(/^\d{6}$/, { message: '验证码必须是数字' })
  code: string;

  @IsBoolean()
  @IsOptional()
  remember?: boolean = false;
}
```

#### src/auth/auth.service.spec.ts

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { JwtService } from '@nestjs/jwt';
import { Repository } from 'typeorm';
import { User } from '../users/user.entity';
import { SmsService } from '../sms/sms.service';
import { RedisService } from '../redis/redis.service';
import { getRepositoryToken } from '@nestjs/typeorm';

describe('AuthService', () => {
  let service: AuthService;
  let mockUserRepository: Partial<Repository<User>>;
  let mockJwtService: Partial<JwtService>;
  let mockSmsService: Partial<SmsService>;
  let mockRedisService: Partial<RedisService>;

  beforeEach(async () => {
    mockUserRepository = {
      findOne: jest.fn(),
      save: jest.fn(),
    };

    mockJwtService = {
      sign: jest.fn().mockReturnValue('mock-token'),
    };

    mockSmsService = {
      send: jest.fn(),
    };

    mockRedisService = {
      get: jest.fn(),
      set: jest.fn(),
      del: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: getRepositoryToken(User), useValue: mockUserRepository },
        { provide: JwtService, useValue: mockJwtService },
        { provide: SmsService, useValue: mockSmsService },
        { provide: RedisService, useValue: mockRedisService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('login', () => {
    it('should return token and user when credentials are valid', async () => {
      // Given
      const phone = '13800138000';
      const code = '123456';
      mockRedisService.get.mockResolvedValue(code);
      mockUserRepository.findOne.mockResolvedValue({ id: '1', phone });

      // When
      const result = await service.login(phone, code);

      // Then
      expect(result.token).toBeDefined();
      expect(result.user).toBeDefined();
    });

    it('should throw error when code is expired', async () => {
      // Given
      const phone = '13800138000';
      const code = '123456';
      mockRedisService.get.mockResolvedValue(null);

      // When & Then
      await expect(service.login(phone, code))
        .rejects
        .toThrow('验证码已过期');
    });

    it('should throw error when code is invalid', async () => {
      // Given
      const phone = '13800138000';
      const wrongCode = '000000';
      mockRedisService.get.mockResolvedValue('123456');

      // When & Then
      await expect(service.login(phone, wrongCode))
        .rejects
        .toThrow('验证码错误');
    });
  });
});
```

### 步骤 4：质量检查

```
请检查以上代码是否满足以下要求：

- [ ] 代码清晰，命名准确
- [ ] 错误处理完善（try-catch、全局过滤器）
- [ ] 日志记录充分（使用 Logger）
- [ ] 测试覆盖完整（> 80%）
- [ ] 符合 SOLID 原则
- [ ] 无安全漏洞（SQL 注入、XSS 等）
- [ ] 函数长度合理（< 50 行）

请逐项检查并指出不足之处。
```

### 步骤 5：保存代码

```bash
# 创建目录
mkdir -p src/auth src/auth/dto tests/auth

# 保存文件
# 复制 AI 生成的代码到对应文件

# 运行测试验证
npm run test auth.service.spec.ts

# 提交代码
git add src/auth/
git commit -m "feat: 实现手机号登录接口"
```

## 完整流转

```
1. PM 创建 PRD → docs/prd/mobile-login.md
2. TL 设计方案 → docs/tech/mobile-login.md, docs/api/auth.yaml
3. Backend 实现 → src/auth/*.ts, tests/auth/*.test.ts  ← 当前步骤
4. Frontend 开发 → src/pages/login/*.tsx
5. QA 编写测试 → tests/e2e/login.spec.ts
6. Code Review → 审查报告
```
