# CI Triage Skill
## 目的
分析CI失败日志，确定问题的根本原因和修复优先级。
## 输入
- GitHub Actions CI运行日志
- 失败的测试名称和错误信息
## 输出
- 问题分类：测试失败、lint错误、构建错误、依赖问题、其他
- 根本原因分析
- 估计修复难度：简单、中等、困难
- 是否可以自动修复：是/否
## 分类规则
- **简单**：语法错误、拼写错误、简单的lint警告
- **中等**：测试失败但错误信息明确、依赖版本冲突
- **困难**：间歇性测试失败、复杂的逻辑错误、性能问题
## 输出格式
```json
{
  "issue_type": "test_failure",
  "root_cause": "The user service is returning null when user not found",
  "difficulty": "medium",
  "auto_fixable": true,
  "file_path": "src/services/user.js",
  "line_number": 42
}