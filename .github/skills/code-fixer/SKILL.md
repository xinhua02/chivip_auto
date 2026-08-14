---
name: code-fixer
description: Fix code problems that caused a CI failure with the smallest change that keeps existing style, adds or fixes the relevant tests, and passes lint and type checks. Use when applying a fix to a diagnosed CI issue.
---

# Code Fixer Skill
## 目的
根据CI失败信息修复代码问题。
## 修复原则
1. 只修复与CI失败直接相关的问题
2. 不要重构不相关的代码
3. 保持代码风格与现有代码一致
4. 如果测试失败，添加或修复相应的测试
5. 所有修复必须通过lint和类型检查
## 输出
- 修改后的代码文件
- 修复说明
- 运行测试的结果