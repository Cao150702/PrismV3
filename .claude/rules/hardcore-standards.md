# 硬核标准 (Hardcore Standards)

## 代码质量标准

### 禁止的模式
- 禁止超过 3 层的嵌套（if/for/while 嵌套）
- 禁止超过 200 行的单个文件（特殊情况需在 DECISIONS.md 记录理由）
- 禁止超过 50 行的单个函数
- 禁止魔法数字（所有数字常量必须命名）
- 禁止忽略错误（catch 块不能为空）
- 禁止使用 `!important`（CSS）

### 强制要求
- 所有公共函数必须有类型签名
- 所有 API 接口必须有请求/响应 schema
- 所有数据库操作必须有迁移脚本
- 所有环境变量必须在 .env.example 中声明
- 所有第三方依赖必须在 DECISIONS.md 中记录选型理由

### 命名规范
- 变量/函数：描述性命名，不用缩写（`getUserById` 不是 `getUsr`）
- 布尔值：`is`/`has`/`should` 前缀
- 事件处理：`handle` 前缀（`handleClick` 不是 `click`）
- 常量：大写蛇形（`MAX_RETRY_COUNT`）

### Git 规范
- Commit message：动词开头现在时（"add user auth" 不是 "added user auth"）
- 一次 commit 只做一件事
- 不提交注释掉的代码
- 不提交调试用的 console.log
