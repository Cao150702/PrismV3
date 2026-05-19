#!/usr/bin/env bash
set -euo pipefail

# PrismV3 Init — 将 AI 开发工作流体系部署到目标项目
# 用法: ./prism3-init.sh <目标项目路径>

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"

usage() {
  echo "用法: prism3-init <目标项目路径>"
  echo ""
  echo "将 PrismV3 AI 开发工作流体系部署到指定项目。"
  echo ""
  echo "示例:"
  echo "  prism3-init ~/my-new-project"
  echo "  prism3-init ."
  exit 1
}

# --- 参数检查 ---
TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  usage
fi

# 解析为绝对路径
if [ ! -d "$TARGET" ]; then
  echo -e "${CYAN}📁 目标目录不存在，自动创建: $TARGET${NC}"
  mkdir -p "$TARGET"
fi

TARGET="$(cd "$TARGET" && pwd)"

# 检查目标是否为空（非空也不阻止，只提示）
if [ "$(ls -A "$TARGET" 2>/dev/null | grep -v '^.git$' | head -1)" ]; then
  echo -e "${CYAN}⚠️  目标目录非空，将在现有文件基础上叠加。${NC}"
  echo -e "${CYAN}   已存在的同名文件会被覆盖。${NC}"
  echo ""
  read -p "继续？(y/N) " confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消。"
    exit 0
  fi
fi

echo ""
echo -e "${GREEN}═══ PrismV3 Init ═══${NC}"
echo -e "${CYAN}目标: $TARGET${NC}"
echo ""

# --- 复制核心文件 ---
echo "📋 复制核心配置..."

cp "$TEMPLATE_DIR/CLAUDE.md"      "$TARGET/CLAUDE.md"
cp "$TEMPLATE_DIR/PROGRESS.md"    "$TARGET/PROGRESS.md"
cp "$TEMPLATE_DIR/DECISIONS.md"   "$TARGET/DECISIONS.md"
cp "$TEMPLATE_DIR/HANDOFF-LOG.md" "$TARGET/HANDOFF-LOG.md"

# --- 复制 .claude 目录 ---
echo "📋 复制 .claude/ 体系..."

mkdir -p "$TARGET/.claude"

# agents
mkdir -p "$TARGET/.claude/agents"
cp "$TEMPLATE_DIR/.claude/agents/explorer.md"     "$TARGET/.claude/agents/explorer.md"
cp "$TEMPLATE_DIR/.claude/agents/implementer.md"   "$TARGET/.claude/agents/implementer.md"
cp "$TEMPLATE_DIR/.claude/agents/reviewer.md"      "$TARGET/.claude/agents/reviewer.md"
cp "$TEMPLATE_DIR/.claude/agents/qa-engineer.md"   "$TARGET/.claude/agents/qa-engineer.md"

# rules
mkdir -p "$TARGET/.claude/rules"
cp "$TEMPLATE_DIR/.claude/rules/dev-principles.md"        "$TARGET/.claude/rules/dev-principles.md"
cp "$TEMPLATE_DIR/.claude/rules/anti-drift.md"            "$TARGET/.claude/rules/anti-drift.md"
cp "$TEMPLATE_DIR/.claude/rules/anti-slacking.md"         "$TARGET/.claude/rules/anti-slacking.md"
cp "$TEMPLATE_DIR/.claude/rules/acceptance-frontend.md"   "$TARGET/.claude/rules/acceptance-frontend.md"
cp "$TEMPLATE_DIR/.claude/rules/acceptance-backend.md"    "$TEMPLATE_DIR/.claude/rules/acceptance-backend.md"
cp "$TEMPLATE_DIR/.claude/rules/decision-nodes.md"        "$TARGET/.claude/rules/decision-nodes.md"
cp "$TEMPLATE_DIR/.claude/rules/goal-driven-execution.md" "$TARGET/.claude/rules/goal-driven-execution.md"
cp "$TEMPLATE_DIR/.claude/rules/handoff-format.md"        "$TARGET/.claude/rules/handoff-format.md"
cp "$TEMPLATE_DIR/.claude/rules/hardcore-standards.md"    "$TARGET/.claude/rules/hardcore-standards.md"
cp "$TEMPLATE_DIR/.claude/rules/karpathy-guidelines.md"   "$TARGET/.claude/rules/karpathy-guidelines.md"
cp "$TEMPLATE_DIR/.claude/rules/research-routing.md"      "$TARGET/.claude/rules/research-routing.md"
cp "$TEMPLATE_DIR/.claude/rules/subagent-constraints.md"  "$TARGET/.claude/rules/subagent-constraints.md"
cp "$TEMPLATE_DIR/.claude/rules/team-protocol.md"         "$TARGET/.claude/rules/team-protocol.md"

# memory
mkdir -p "$TARGET/.claude/memory"
cp "$TEMPLATE_DIR/.claude/memory/decisions.md"  "$TARGET/.claude/memory/decisions.md"
cp "$TEMPLATE_DIR/.claude/memory/scratchpad.md" "$TARGET/.claude/memory/scratchpad.md"

# plans
mkdir -p "$TARGET/.claude/plans"
cp "$TEMPLATE_DIR/.claude/plans/active-plan.md" "$TARGET/.claude/plans/active-plan.md"

# skills
mkdir -p "$TARGET/.claude/skills"
cp "$TEMPLATE_DIR/.claude/skills/README.md" "$TARGET/.claude/skills/README.md"

# plugins
mkdir -p "$TARGET/.claude/plugins"
cp "$TEMPLATE_DIR/.claude/plugins/README.md" "$TARGET/.claude/plugins/README.md"

# --- 更新 HANDOFF-LOG.md 初始化记录 ---
cat > "$TARGET/HANDOFF-LOG.md" << HANDOFF_EOF
# HANDOFF-LOG.md — 跨会话交接日志

## 交接记录

### $(date +%Y-%m-%d) — 项目初始化

- **执行者**：PrismV3 Init 脚本
- **做了什么**：从模板部署 PrismV3 AI 开发工作流体系
- **做到哪一步**：体系就绪，等待第一个开发任务
- **下一个会话注意事项**：
  - CLAUDE.md 已配置，启动 Claude Code 时自动加载
  - 开始新任务前先检查 PROGRESS.md
  - 做任何技术决策后更新 DECISIONS.md
  - 会话结束前写交接记录到本文件
- **遗留风险**：无
- **产出物**：PrismV3 工作流完整文件集

---

### 会话 #（模板）

- **执行者**：
- **做了什么**：
- **做到哪一步**：
- **下一个会话注意事项**：
- **遗留风险**：
- **产出物**：
HANDOFF_EOF

# --- 完成 ---
echo ""
echo -e "${GREEN}✅ PrismV3 工作流体系部署完成！${NC}"
echo ""
echo -e "${CYAN}已部署的文件:${NC}"
echo "  $TARGET/CLAUDE.md"
echo "  $TARGET/PROGRESS.md"
echo "  $TARGET/DECISIONS.md"
echo "  $TARGET/HANDOFF-LOG.md"
echo "  $TARGET/.claude/     (agents/ rules/ memory/ plans/ skills/ plugins/)"
echo ""
echo -e "${CYAN}下一步:${NC}"
echo "  cd $TARGET"
echo "  claude    # 启动 Claude Code，CLAUDE.md 自动加载"
echo ""
echo -e "${CYAN}别忘了根据你的技术栈微调:${NC}"
echo "  - .claude/rules/hardcore-standards.md (语言/框架具体规范)"
echo "  - DECISIONS.md 的项目上下文"
