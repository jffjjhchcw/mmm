# Infinity X GitHub  Actions 编译指南

## 步骤 1: 创建 GitHub 仓库

1. 打开 https://github.com/new
2. 创建新仓库，命名为: `infinity-x-pgjm10`
3. 选择 **Public**
4. 点击 "Create repository"

## 步骤 2: 上传文件

```bash
# 在本地终端:
cd /home/admi/桌面/新建文件夹\ 1

# 初始化 git
git init

# 添加所有文件
git add .
git add -f .github/workflows/build.yml

# 提交
git commit -m "OPPO K10 5G Infinity X device tree"

# 添加远程仓库 (替换为你的仓库 URL)
git remote add origin https://github.com/你的用户名/infinity-x-pgjm10.git

# 推送
git branch -M main
git push -u origin main
```

## 步骤 3: 触发编译

1. 打开你的 GitHub 仓库页面
2. 点击 "Actions" 标签
3. 点击 "Build Infinity X"
4. 点击 "Run workflow"
5. 选择分支 (16 for Android 16)
6. 点击 "Run workflow"

## 步骤 4: 下载 ROM

编译完成后 (约 2-4 小时):
1. 进入 Actions → 你的编译任务
2. 点击 "Summary"
3. 在 Artifacts 部分下载 ROM

---

## 注意事项

1. **GitHub 免费版有运行时间限制**: 每月约 2000 分钟
2. **仓库需设为 Public** 才能使用免费 Actions
3. **编译可能需要多次尝试** 如果遇到错误，需要修复后重新提交

---

## 仓库文件结构

```
infinity-x-pgjm10/
├── .github/
│   └── workflows/
│       └── build.yml          # 编译脚本
├── device_tree/
│   └── pgjm10/                # 设备树
│       ├── vendor/             # Vendor blobs
│       ├── BoardConfig.mk
│       ├── pgjm10.mk
│       └── ...
└── README.md
```

准备好了告诉我，我来帮你检查上传命令。
