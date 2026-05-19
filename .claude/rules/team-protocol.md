# 团队协作协议 (Team Protocol)

## 角色协作流程

### 标准开发流程
```
用户提需求
    ↓
Coordinator（头脑风暴 + 定方案）
    ↓
Coordinator 写派单 → Implementer
    ↓
Implementer 在 worktree 中开发（TDD）
    ↓
Implementer 提交 → Coordinator 检查
    ↓
Coordinator 发派单 → Reviewer（只读审查）
    ↓
Reviewer 出审查报告 → Coordinator 审阅
    ↓（通过）
Coordinator 发派单 → QA Engineer（E2E 测试）
    ↓
QA Engineer 出测试报告 → Coordinator
    ↓（通过）
合并 + 更新 PROGRESS.md + DECISIONS.md
    ↓
Coordinator 写 Handoff 记录
```

### 升级路径
```
问题出现
    ↓
第 1-3 次尝试：AI 自行修复
    ↓（失败）
第 4-8 次尝试：换一个 agent 视角（比如 Reviewer 来看问题）
    ↓（还失败）
写 Blocker 报告 → 等待用户介入
```

### 通信规则
- Agent 之间不直接通信，必须通过 Coordinator 中转
- 所有派单和报告都以文件形式存放在 .claude/plans/
- Handoff 文件是会话间通信的唯一渠道

### 冲突处理
- 如果 Reviewer 和 Implementer 意见不一致 → Coordinator 裁决
- 如果 QA 发现的问题 Implementer 不认可 → 以 QA 的实际测试结果为准
- 如果 Coordinator 不确定 → 问用户（附两方论据）
