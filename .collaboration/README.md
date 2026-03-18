# `.collaboration`

协作产物统一保存在仓库根目录的 `.collaboration/` 下，不再放在 `docs/` 里。

## 目录约定

```text
.collaboration/
├── features/
│   └── {feature-name}/
│       ├── prd.md
│       ├── tech.md
│       ├── api.yaml
│       ├── plan.md
│       ├── stories.md
│       ├── test-report.md
│       └── bugs/
│           └── {bug-id}.md
└── shared/
    ├── coding-standards.md
    └── db/
        └── schema.sql
```

## Slug 规则

- `{feature-name}` 只是模板占位符，不是会自动共享的系统变量。
- 实际 feature slug 在首次创建 PRD 时确定，并在后续流程中保持不变。
- slug 使用小写 kebab-case，例如 `mobile-login`、`payment-refund`。

## 使用示例

- `@.collaboration/features/mobile-login/prd.md`
- `@.collaboration/features/mobile-login/tech.md`
- `@.collaboration/features/mobile-login/api.yaml`
- `@.collaboration/shared/db/schema.sql`
