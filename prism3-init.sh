#!/usr/bin/env bash
set -uo pipefail

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
  echo -e "${CYAN}目标目录不存在，自动创建: $TARGET${NC}"
  mkdir -p "$TARGET" || { echo -e "${RED}无法创建目录: $TARGET${NC}"; exit 1; }
fi

TARGET="$(cd "$TARGET" && pwd)"

# 检查是否和模板是同一个目录
if [ "$TARGET" = "$TEMPLATE_DIR" ]; then
  echo -e "${RED}错误: 目标不能和 PrismV3 模板是同一个目录${NC}"
  exit 1
fi

# 检查目标是否为空（非空也不阻止，只提示）
if [ "$(ls -A "$TARGET" 2>/dev/null | grep -v '^.git$' | head -1)" ]; then
  echo -e "${CYAN}目标目录非空，将在现有文件基础上叠加。${NC}"
  echo -e "${CYAN}已存在的同名文件会被覆盖。${NC}"
  echo ""
  read -p "继续？(y/N) " confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消。"
    exit 0
  fi
fi

echo ""
echo -e "${GREEN}=== PrismV3 Init ===${NC}"
echo -e "${CYAN}模板: $TEMPLATE_DIR${NC}"
echo -e "${CYAN}目标: $TARGET${NC}"
echo ""

# --- 创建所有目录 ---
mkdir -p "$TARGET/.claude"/{agents,rules,memory,plans,skills,plugins}

# --- 复制函数（忽略"文件相同"的警告）---
copy_file() {
  local src="$1"
  local dst="$2"
  if [ ! -f "$src" ]; then
    echo -e "${RED}  模板文件缺失: $src${NC}"
    return 1
  fi
  # 用 rsync 替代 cp，避免"文件相同"导致非零退出码
  if command -v rsync &>/dev/null; then
    rsync -a "$src" "$dst" 2>/dev/null
  else
    cp -f "$src" "$dst" 2>/dev/null || true
  fi
}

echo "复制核心配置..."
copy_file "$TEMPLATE_DIR/CLAUDE.md"      "$TARGET/CLAUDE.md"
copy_file "$TEMPLATE_DIR/PROGRESS.md"    "$TARGET/PROGRESS.md"
copy_file "$TEMPLATE_DIR/DECISIONS.md"   "$TARGET/DECISIONS.md"
copy_file "$TEMPLATE_DIR/HANDOFF-LOG.md" "$TARGET/HANDOFF-LOG.md"

echo "复制 agents..."
for f in explorer implementer reviewer qa-engineer; do
  copy_file "$TEMPLATE_DIR/.claude/agents/${f}.md" "$TARGET/.claude/agents/${f}.md"
done

echo "复制 rules..."
for f in dev-principles anti-drift anti-slacking acceptance-frontend acceptance-backend \
         decision-nodes goal-driven-execution handoff-format hardcore-standards \
         karpathy-guidelines research-routing subagent-constraints team-protocol; do
  copy_file "$TEMPLATE_DIR/.claude/rules/${f}.md" "$TARGET/.claude/rules/${f}.md"
done

echo "复制 memory/plans/skills/plugins..."
copy_file "$TEMPLATE_DIR/.claude/memory/decisions.md"  "$TARGET/.claude/memory/decisions.md"
copy_file "$TEMPLATE_DIR/.claude/memory/scratchpad.md" "$TARGET/.claude/memory/scratchpad.md"
copy_file "$TEMPLATE_DIR/.claude/plans/active-plan.md" "$TARGET/.claude/plans/active-plan.md"
copy_file "$TEMPLATE_DIR/.claude/skills/README.md"     "$TARGET/.claude/skills/README.md"
copy_file "$TEMPLATE_DIR/.claude/plugins/README.md"    "$TARGET/.claude/plugins/README.md"

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
echo -e "${GREEN}PrismV3 工作流体系部署完成！${NC}"
echo ""
echo -e "${CYAN}已部署:${NC}"
echo "  $TARGET/CLAUDE.md"
echo "  $TARGET/PROGRESS.md"
echo "  $TARGET/DECISIONS.md"
echo "  $TARGET/HANDOFF-LOG.md"
echo "  $TARGET/.claude/  (agents/ rules/ memory/ plans/ skills/ plugins/)"
echo ""
echo -e "${CYAN}下一步:${NC}"
echo "  cd $TARGET && claude"
echo ""
echo -e "${CYAN}按需微调:${NC}"
echo "  .claude/rules/hardcore-standards.md  (语言/框架规范)"
echo "  DECISIONS.md  (项目上下文)"
