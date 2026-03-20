# `.collaboration`

协作产物统一保存在仓库根目录的 `.collaboration/` 下，作为 Feature / Bug 双主链路的文档工作区。

## 目录约定

```text
.collaboration/
├── features/
│   └── {feature-name}/
│       ├── prd.md
│       ├── plan.md
│       ├── tech.md
│       ├── api.yaml
│       ├── design.md
│       ├── design-components.md
│       ├── review.md
│       ├── test-cases.md
│       ├── qa-report.md
│       ├── code-review.md
│       └── security-review.md
├── bugs/
│   └── {bug-name}/
│       ├── bug.md
│       ├── fix-plan.md
│       ├── design-change.md
│       ├── execution-plan.md
│       ├── frontend-handoff.md
│       ├── backend-handoff.md
│       ├── test-cases.md
│       ├── qa-report.md
│       ├── code-review.md
│       └── security-review.md
└── shared/
    └── db/
```

说明：

- `features/` 与 `bugs/` 下的具体目录按需创建，仓库不会预先为每个工作项生成空目录。
- `shared/` 当前只保留公共数据库或共享资料的占位目录，不参与主链路同步脚本。
- 实现代码、测试代码和业务仓 PR 不写入 `.collaboration/`，这里只存协作文档。
- `.collaboration/features/{feature-name}/qa-report.md`、`.collaboration/features/{feature-name}/security-review.md` 以及对应 Bug 路径属于按需产物；目录树中列出它们是为了统一路径约定，不代表每个工作项都必须生成。

## Slug 规则

- `{feature-name}` 与 `{bug-name}` 都是模板占位符，不是自动注入的系统变量。
- Feature slug 在首次产出 `.collaboration/features/{feature-name}/prd.md` 时确定，并在后续流程中保持不变。
- Bug slug 在首次补齐 `.collaboration/bugs/{bug-name}/bug.md` 时确定，并在后续流程中保持不变。
- slug 使用小写 kebab-case，例如 `mobile-login`、`payment-submit-500`。

## 使用示例

- `@.collaboration/features/mobile-login/prd.md`
- `@.collaboration/features/mobile-login/api.yaml`
- `@.collaboration/features/mobile-login/design-components.md`
- `@.collaboration/features/mobile-login/code-review.md`
- `@.collaboration/bugs/payment-submit-500/bug.md`
- `@.collaboration/bugs/payment-submit-500/backend-handoff.md`

## 相关文档

- [README.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/README.md)
- [QUICKSTART.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/QUICKSTART.md)
- [docs/multi-repo-best-practices.md](/Users/yuqiyu/AiHistorys/team-collaboration-skills/docs/multi-repo-best-practices.md)
