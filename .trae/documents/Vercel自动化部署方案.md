# Vercel 自动化部署方案

太棒了！使用 Vercel 是非常专业的选择，也是现代前端开发的标准流程。
既然是作业，老师通常希望看到：**代码在 GitHub 仓库 + 网站在 Vercel 运行 + 每次修改代码自动更新网站**。

这正是 Vercel 的强项：**您只需要把代码推送到 GitHub，Vercel 就会自动帮您发布更新**，再也不用手动上传文件了。

## 方案步骤

### 第一步：关联 GitHub 仓库（一次性设置）
刚才检测到您的本地还没有关联远程仓库。我们需要把本地的代码和 GitHub 连起来。
**请在下方的终端（Terminal）里运行这两行命令**（我无法代劳，因为涉及您的账号权限）：

```bash
git remote add origin https://github.com/Four-seven-4-7/ai-daily-review.git
git push -u origin master
```
*(如果提示输入密码，请输入您的 GitHub Personal Access Token；或者如果您的 VS Code 已经登录了 GitHub，它会自动认证)*

### 第二步：在 Vercel 导入项目（一次性设置）
1.  访问 [vercel.com](https://vercel.com) 并使用 GitHub 账号登录。
2.  点击 **"Add New..."** -> **"Project"**。
3.  在 "Import Git Repository" 列表中，找到 `ai-daily-review`，点击 **Import**。
4.  直接点击 **Deploy**（因为我们是纯 HTML，不需要改任何构建配置）。

### 第三步：享受自动化
以后您想更新网站，只需要在 VS Code 里做两件事：
1.  修改代码并保存。
2.  在终端运行：
    ```bash
    git add .
    git commit -m "update"
    git push
    ```
Vercel 就会自动检测到更新，并重新发布您的网站！

---
**现在，请先在终端运行第一步的命令，把代码推送到 GitHub。**
(成功后告诉我，我再教您 Vercel 的细节)