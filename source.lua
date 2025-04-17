local colorSettings = {
    ["Main"] = {
        ["HeaderColor"] = Color3.fromRGB(25, 35, 50),
        ["HeaderShadingColor"] = Color3.fromRGB(20, 30, 45),
        ["HeaderTextColor"] = Color3.fromRGB(240, 240, 240),
        ["MainBackgroundColor"] = Color3.fromRGB(30, 40, 55),
        ["InfoScrollingFrameBgColor"] = Color3.fromRGB(25, 35, 50),
        ["ScrollBarImageColor"] = Color3.fromRGB(100, 120, 150)
    },
    ["RemoteButtons"] = {
        ["BorderColor"] = Color3.fromRGB(60, 70, 90),
        ["BackgroundColor"] = Color3.fromRGB(40, 50, 65),
        ["TextColor"] = Color3.fromRGB(240, 240, 240),
        ["NumberTextColor"] = Color3.fromRGB(180, 180, 180),
        ["HoverColor"] = Color3.fromRGB(50, 60, 75),
        ["PressedColor"] = Color3.fromRGB(30, 40, 55)
    },
    ["MainButtons"] = { 
        ["BorderColor"] = Color3.fromRGB(70, 80, 100),
        ["BackgroundColor"] = Color3.fromRGB(50, 60, 80),
        ["TextColor"] = Color3.fromRGB(240, 240, 240),
        ["HoverColor"] = Color3.fromRGB(60, 70, 90),
        ["PressedColor"] = Color3.fromRGB(40, 50, 70),
        ["SuccessColor"] = Color3.fromRGB(70, 200, 50),
        ["WarningColor"] = Color3.fromRGB(240, 180, 40),
        ["ErrorColor"] = Color3.fromRGB(220, 60, 30)
    },
    ['Code'] = {
        ['BackgroundColor'] = Color3.fromRGB(25, 30, 40),
        ['TextColor'] = Color3.fromRGB(220, 221, 225),
        ['CreditsColor'] = Color3.fromRGB(150, 150, 150)
    },
}

local settings = {
["Keybind"] = "P"
}

if PROTOSMASHER_LOADED then
    getgenv().isfile = newcclosure(function(File)
        local Suc, Er = pcall(readfile, File)
        if not Suc then
            return false
        end
        return true
    end
end

local HttpService = game:GetService("HttpService")
if not isfile("ArabSpySettings.json") then
    writefile("ArabSpySettings.json", HttpService:JSONEncode(settings))
else
    if HttpService:JSONDecode(readfile("ArabSpySettings.json"))["Main"] then
        writefile("ArabSpySettings.json", HttpService:JSONEncode(settings))
    else
        settings = HttpService:JSONDecode(readfile("ArabSpySettings.json"))
    end
end

function isSynapse()
    if PROTOSMASHER_LOADED then
        return false
    else
    return true
    end
end

function Parent(GUI)
    if syn and syn.protect_gui then
        syn.protect_gui(GUI)
        GUI.Parent = game:GetService("CoreGui")
    elseif PROTOSMASHER_LOADED then
        GUI.Parent = get_hidden_gui()
    else
        GUI.Parent = game:GetService("CoreGui")
    end
end

local client = game.Players.LocalPlayer
local function toUnicode(string)
    local codepoints = "utf8.char("
    for _i, v in utf8.codes(string) do
        codepoints = codepoints .. v .. ', '
    end
    return codepoints:sub(1, -3) .. ')'
end

local function GetFullPathOfAnInstance(instance)
    local name = instance.Name
    local head = (#name > 0 and '.' .. name) or "['']"
    if not instance.Parent and instance ~= game then
        return head .. " --[[ PARENTED TO NIL OR DESTROYED ]]"
    end
    if instance == game then
        return "game"
    elseif instance == workspace then
        return "workspace"
    else
        local _success, result = pcall(game.GetService, game, instance.ClassName)
        if result then
            head = ':GetService("' .. instance.ClassName .. '")'
        elseif instance == client then
            head = '.LocalPlayer' 
        else
            local nonAlphaNum = name:gsub('[%w_]', '')
            local noPunct = nonAlphaNum:gsub('[%s%p]', '')
            if tonumber(name:sub(1, 1)) or (#nonAlphaNum ~= 0 and #noPunct == 0) then
                head = '["' .. name:gsub('"', '\\"'):gsub('\\', '\\\\') .. '"]'
            elseif #nonAlphaNum ~= 0 and #noPunct > 0 then
                head = '[' .. toUnicode(name) .. ']'
            end
        end
    end
    return GetFullPathOfAnInstance(instance.Parent) .. head
end

local isA = game.IsA
local clone = game.Clone
local TextService = game:GetService("TextService")
local getTextSize = TextService.GetTextSize
game.StarterGui.ResetPlayerGuiOnSpawn = false
local mouse = game.Players.LocalPlayer:GetMouse()

if game.CoreGui:FindFirstChild("ArabSpyGUI") then
    game.CoreGui.ArabSpyGUI:Destroy()
end

local buttonOffset = -25
local scrollSizeOffset = 287
local functionImage = "http://www.roblox.com/asset/?id=413369623"
local eventImage = "http://www.roblox.com/asset/?id=413369506"
local remotes = {}
local remoteArgs = {}
local remoteButtons = {}
local remoteScripts = {}
local IgnoreList = {}
local BlockList = {}
local IgnoreList = {}
local connections = {}
local unstacked = {}

local ArabSpyGUI = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local HeaderShading = Instance.new("Frame")
local HeaderTextLabel = Instance.new("TextLabel")
local RemoteScrollFrame = Instance.new("ScrollingFrame")
local RemoteButton = Instance.new("TextButton")
local Number = Instance.new("TextLabel")
local RemoteName = Instance.new("TextLabel")
local RemoteIcon = Instance.new("ImageLabel")
local InfoFrame = Instance.new("Frame")
local InfoFrameHeader = Instance.new("Frame")
local InfoTitleShading = Instance.new("Frame")
local CodeFrame = Instance.new("ScrollingFrame")
local Code = Instance.new("TextLabel")
local CodeComment = Instance.new("TextLabel")
local InfoHeaderText = Instance.new("TextLabel")
local InfoButtonsScroll = Instance.new("ScrollingFrame")
local CopyCode = Instance.new("TextButton")
local RunCode = Instance.new("TextButton")
local CopyScriptPath = Instance.new("TextButton")
local CopyDecompiled = Instance.new("TextButton")
local IgnoreRemote = Instance.new("TextButton")
local BlockRemote = Instance.new("TextButton")
local WhileLoop = Instance.new("TextButton")
local CopyReturn = Instance.new("TextButton")
local Clear = Instance.new("TextButton")
local FrameDivider = Instance.new("Frame")
local CloseInfoFrame = Instance.new("TextButton")
local OpenInfoFrame = Instance.new("TextButton")
local Minimize = Instance.new("TextButton")
local DoNotStack = Instance.new("TextButton")
local ImageButton = Instance.new("ImageButton")

ArabSpyGUI.Name = "ArabSpyGUI"
Parent(ArabSpyGUI)

mainFrame.Name = "mainFrame"
mainFrame.Parent = ArabSpyGUI
mainFrame.BackgroundColor3 = colorSettings["Main"]["MainBackgroundColor"]
mainFrame.BorderColor3 = colorSettings["Main"]["MainBackgroundColor"]
mainFrame.Position = UDim2.new(0.1, 0, 0.24, 0)
mainFrame.Size = UDim2.new(0, 207, 0, 35)
mainFrame.ZIndex = 8
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

Header.Name = "Header"
Header.Parent = mainFrame
Header.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
Header.BorderColor3 = colorSettings["Main"]["HeaderColor"]
Header.Size = UDim2.new(0, 207, 0, 26)
Header.ZIndex = 9

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = Header

HeaderShading.Name = "HeaderShading"
HeaderShading.Parent = Header
HeaderShading.BackgroundColor3 = colorSettings["Main"]["HeaderShadingColor"]
HeaderShading.BorderColor3 = colorSettings["Main"]["HeaderShadingColor"]
HeaderShading.Position = UDim2.new(0, 0, 0.285, 0)
HeaderShading.Size = UDim2.new(0, 207, 0, 27)
HeaderShading.ZIndex = 8

HeaderTextLabel.Name = "HeaderTextLabel"
HeaderTextLabel.Parent = HeaderShading
HeaderTextLabel.BackgroundTransparency = 1
HeaderTextLabel.Position = UDim2.new(-0.005, 0, -0.203, 0)
HeaderTextLabel.Size = UDim2.new(0, 215, 0, 29)
HeaderTextLabel.ZIndex = 10
HeaderTextLabel.Font = Enum.Font.GothamBold
HeaderTextLabel.Text = "Arab Spy"
HeaderTextLabel.TextColor3 = colorSettings["Main"]["HeaderTextColor"]
HeaderTextLabel.TextSize = 17

RemoteScrollFrame.Name = "RemoteScrollFrame"
RemoteScrollFrame.Parent = mainFrame
RemoteScrollFrame.Active = true
RemoteScrollFrame.BackgroundColor3 = colorSettings["Main"]["InfoScrollingFrameBgColor"]
RemoteScrollFrame.BorderColor3 = colorSettings["Main"]["InfoScrollingFrameBgColor"]
RemoteScrollFrame.Position = UDim2.new(0, 0, 1.023, 0)
RemoteScrollFrame.Size = UDim2.new(0, 207, 0, 286)
RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 287)
RemoteScrollFrame.ScrollBarThickness = 8
RemoteScrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
RemoteScrollFrame.ScrollBarImageColor3 = colorSettings["Main"]["ScrollBarImageColor"]

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = RemoteScrollFrame

RemoteButton.Name = "RemoteButton"
RemoteButton.Parent = RemoteScrollFrame
RemoteButton.BackgroundColor3 = colorSettings["RemoteButtons"]["BackgroundColor"]
RemoteButton.BorderColor3 = colorSettings["RemoteButtons"]["BorderColor"]
RemoteButton.Position = UDim2.new(0, 17, 0, 10)
RemoteButton.Size = UDim2.new(0, 182, 0, 26)
RemoteButton.Selected = true
RemoteButton.Font = Enum.Font.Gotham
RemoteButton.Text = ""
RemoteButton.TextColor3 = colorSettings["RemoteButtons"]["TextColor"]
RemoteButton.TextSize = 18
RemoteButton.TextStrokeTransparency = 123
RemoteButton.TextWrapped = true
RemoteButton.TextXAlignment = Enum.TextXAlignment.Left
RemoteButton.Visible = false

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = RemoteButton

RemoteButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        RemoteButton,
        TweenInfo.new(0.15),
        {BackgroundColor3 = colorSettings["RemoteButtons"]["HoverColor"]}
    ):Play()
end)

RemoteButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        RemoteButton,
        TweenInfo.new(0.15),
        {BackgroundColor3 = colorSettings["RemoteButtons"]["BackgroundColor"]}
    ):Play()
end)

RemoteButton.MouseButton1Down:Connect(function()
    game:GetService("TweenService"):Create(
        RemoteButton,
        TweenInfo.new(0.1),
        {BackgroundColor3 = colorSettings["RemoteButtons"]["PressedColor"]}
    ):Play()
end)

RemoteButton.MouseButton1Up:Connect(function()
    game:GetService("TweenService"):Create(
        RemoteButton,
        TweenInfo.new(0.15),
        {BackgroundColor3 = colorSettings["RemoteButtons"]["HoverColor"]}
    ):Play()
end)

Number.Name = "Number"
Number.Parent = RemoteButton
Number.BackgroundTransparency = 1
Number.Position = UDim2.new(0, 5, 0, 0)
Number.Size = UDim2.new(0, 300, 0, 26)
Number.ZIndex = 2
Number.Font = Enum.Font.Gotham
Number.Text = "1"
Number.TextColor3 = colorSettings["RemoteButtons"]["NumberTextColor"]
Number.TextSize = 16
Number.TextWrapped = true
Number.TextXAlignment = Enum.TextXAlignment.Left

RemoteName.Name = "RemoteName"
RemoteName.Parent = RemoteButton
RemoteName.BackgroundTransparency = 1
RemoteName.Position = UDim2.new(0, 20, 0, 0)
RemoteName.Size = UDim2.new(0, 134, 0, 26)
RemoteName.Font = Enum.Font.Gotham
RemoteName.Text = "RemoteEvent"
RemoteName.TextColor3 = colorSettings["RemoteButtons"]["TextColor"]
RemoteName.TextSize = 16
RemoteName.TextXAlignment = Enum.TextXAlignment.Left
RemoteName.TextTruncate = 1

RemoteIcon.Name = "RemoteIcon"
RemoteIcon.Parent = RemoteButton
RemoteIcon.BackgroundTransparency = 1
RemoteIcon.Position = UDim2.new(0.84, 0, 0.023, 0)
RemoteIcon.Size = UDim2.new(0, 24, 0, 24)
RemoteIcon.Image = eventImage

InfoFrame.Name = "InfoFrame"
InfoFrame.Parent = mainFrame
InfoFrame.BackgroundColor3 = colorSettings["Main"]["MainBackgroundColor"]
InfoFrame.BorderColor3 = colorSettings["Main"]["MainBackgroundColor"]
InfoFrame.Position = UDim2.new(0.368, 0, 0, 0)
InfoFrame.Size = UDim2.new(0, 357, 0, 322)
InfoFrame.Visible = false
InfoFrame.ZIndex = 6

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = InfoFrame

InfoFrameHeader.Name = "InfoFrameHeader"
InfoFrameHeader.Parent = InfoFrame
InfoFrameHeader.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
InfoFrameHeader.BorderColor3 = colorSettings["Main"]["HeaderColor"]
InfoFrameHeader.Size = UDim2.new(0, 357, 0, 26)
InfoFrameHeader.ZIndex = 14

InfoTitleShading.Name = "InfoTitleShading"
InfoTitleShading.Parent = InfoFrame
InfoTitleShading.BackgroundColor3 = colorSettings["Main"]["HeaderShadingColor"]
InfoTitleShading.BorderColor3 = colorSettings["Main"]["HeaderShadingColor"]
InfoTitleShading.Position = UDim2.new(-0.003, 0, 0, 0)
InfoTitleShading.Size = UDim2.new(0, 358, 0, 34)
InfoTitleShading.ZIndex = 13

CodeFrame.Name = "CodeFrame"
CodeFrame.Parent = InfoFrame
CodeFrame.Active = true
CodeFrame.BackgroundColor3 = colorSettings["Code"]["BackgroundColor"]
CodeFrame.BorderColor3 = colorSettings["Code"]["BackgroundColor"]
CodeFrame.Position = UDim2.new(0.039, 0, 0.141, 0)
CodeFrame.Size = UDim2.new(0, 329, 0, 63)
CodeFrame.ZIndex = 16
CodeFrame.CanvasSize = UDim2.new(0, 670, 2, 0)
CodeFrame.ScrollBarThickness = 8
CodeFrame.ScrollingDirection = 1
CodeFrame.ScrollBarImageColor3 = colorSettings["Main"]["ScrollBarImageColor"]

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 6)
codeCorner.Parent = CodeFrame

Code.Name = "Code"
Code.Parent = CodeFrame
Code.BackgroundTransparency = 1
Code.Position = UDim2.new(0.009, 0, 0.039, 0)
Code.Size = UDim2.new(0, 100000, 0, 25)
Code.ZIndex = 18
Code.Font = Enum.Font.RobotoMono
Code.Text = "Thanks for using Arab Spy! :D"
Code.TextColor3 = colorSettings["Code"]["TextColor"]
Code.TextSize = 14
Code.TextWrapped = true
Code.TextXAlignment = Enum.TextXAlignment.Left

CodeComment.Name = "CodeComment"
CodeComment.Parent = CodeFrame
CodeComment.BackgroundTransparency = 1
CodeComment.Position = UDim2.new(0.012, 0, -0.002, 0)
CodeComment.Size = UDim2.new(0, 1000, 0, 25)
CodeComment.ZIndex = 18
CodeComment.Font = Enum.Font.RobotoMono
CodeComment.Text = "-- Script generated by ArabSpy, made by Gizmoscat"
CodeComment.TextColor3 = colorSettings["Code"]["CreditsColor"]
CodeComment.TextSize = 14
CodeComment.TextXAlignment = Enum.TextXAlignment.Left

InfoHeaderText.Name = "InfoHeaderText"
InfoHeaderText.Parent = InfoFrame
InfoHeaderText.BackgroundTransparency = 1
InfoHeaderText.Position = UDim2.new(0.039, 0, -0.002, 0)
InfoHeaderText.Size = UDim2.new(0, 342, 0, 35)
InfoHeaderText.ZIndex = 18
InfoHeaderText.Font = Enum.Font.GothamBold
InfoHeaderText.Text = "Info: RemoteFunction"
InfoHeaderText.TextColor3 = colorSettings["Main"]["HeaderTextColor"]
InfoHeaderText.TextSize = 17

InfoButtonsScroll.Name = "InfoButtonsScroll"
InfoButtonsScroll.Parent = InfoFrame
InfoButtonsScroll.Active = true
InfoButtonsScroll.BackgroundColor3 = colorSettings["Main"]["MainBackgroundColor"]
InfoButtonsScroll.BorderColor3 = colorSettings["Main"]["MainBackgroundColor"]
InfoButtonsScroll.Position = UDim2.new(0.039, 0, 0.356, 0)
InfoButtonsScroll.Size = UDim2.new(0, 329, 0, 199)
InfoButtonsScroll.ZIndex = 11
InfoButtonsScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
InfoButtonsScroll.ScrollBarThickness = 8
InfoButtonsScroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
InfoButtonsScroll.ScrollBarImageColor3 = colorSettings["Main"]["ScrollBarImageColor"]

local buttonsScrollCorner = Instance.new("UICorner")
buttonsScrollCorner.CornerRadius = UDim.new(0, 6)
buttonsScrollCorner.Parent = InfoButtonsScroll

local function createActionButton(name, text, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = InfoButtonsScroll
    button.BackgroundColor3 = colorSettings["MainButtons"]["BackgroundColor"]
    button.BorderColor3 = colorSettings["MainButtons"]["BorderColor"]
    button.BorderSizePixel = 1
    button.Position = position
    button.Size = UDim2.new(0, 294, 0, 26)
    button.ZIndex = 15
    button.Font = Enum.Font.GothamMedium
    button.Text = text
    button.TextColor3 = colorSettings["MainButtons"]["TextColor"]
    button.TextSize = 14
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = colorSettings["MainButtons"]["HoverColor"]}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = colorSettings["MainButtons"]["BackgroundColor"]}
        ):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.1),
            {BackgroundColor3 = colorSettings["MainButtons"]["PressedColor"]}
        ):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = colorSettings["MainButtons"]["HoverColor"]}
        ):Play()
    end)
    
    return button
end

CopyCode = createActionButton("CopyCode", "Copy code", UDim2.new(0.0645, 0, 0, 10))
RunCode = createActionButton("RunCode", "Execute", UDim2.new(0.0645, 0, 0, 45))
CopyScriptPath = createActionButton("CopyScriptPath", "Copy script path", UDim2.new(0.0645, 0, 0, 80))
CopyDecompiled = createActionButton("CopyDecompiled", "Copy decompiled script", UDim2.new(0.0645, 0, 0, 115))
IgnoreRemote = createActionButton("IgnoreRemote", "Ignore remote", UDim2.new(0.0645, 0, 0, 185))
BlockRemote = createActionButton("BlockRemote", "Block remote from firing", UDim2.new(0.0645, 0, 0, 220))
WhileLoop = createActionButton("WhileLoop", "Generate while loop script", UDim2.new(0.0645, 0, 0, 290))
Clear = createActionButton("Clear", "Clear logs", UDim2.new(0.0645, 0, 0, 255))
CopyReturn = createActionButton("CopyReturn", "Execute and copy return value", UDim2.new(0.0645, 0, 0, 325))
DoNotStack = createActionButton("DoNotStack", "Unstack remote when fired with new args", UDim2.new(0.0645, 0, 0, 150))

FrameDivider.Name = "FrameDivider"
FrameDivider.Parent = InfoFrame
FrameDivider.BackgroundColor3 = colorSettings["Main"]["HeaderShadingColor"]
FrameDivider.BorderColor3 = colorSettings["Main"]["HeaderShadingColor"]
FrameDivider.Position = UDim2.new(0, 3, 0, 0)
FrameDivider.Size = UDim2.new(0, 4, 0, 322)
FrameDivider.ZIndex = 7

local InfoFrameOpen = false
CloseInfoFrame.Name = "CloseInfoFrame"
CloseInfoFrame.Parent = InfoFrame
CloseInfoFrame.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
CloseInfoFrame.BorderColor3 = colorSettings["Main"]["HeaderColor"]
CloseInfoFrame.Position = UDim2.new(0, 333, 0, 2)
CloseInfoFrame.Size = UDim2.new(0, 22, 0, 22)
CloseInfoFrame.ZIndex = 18
CloseInfoFrame.Font = Enum.Font.GothamBold
CloseInfoFrame.Text = "×"
CloseInfoFrame.TextColor3 = Color3.fromRGB(240, 240, 240)
CloseInfoFrame.TextSize = 20
CloseInfoFrame.MouseButton1Click:Connect(function()
    InfoFrame.Visible = false
    InfoFrameOpen = false
    mainFrame.Size = UDim2.new(0, 207, 0, 35)
end)

OpenInfoFrame.Name = "OpenInfoFrame"
OpenInfoFrame.Parent = mainFrame
OpenInfoFrame.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
OpenInfoFrame.BorderColor3 = colorSettings["Main"]["HeaderColor"]
OpenInfoFrame.Position = UDim2.new(0, 185, 0, 2)
OpenInfoFrame.Size = UDim2.new(0, 22, 0, 22)
OpenInfoFrame.ZIndex = 18
OpenInfoFrame.Font = Enum.Font.GothamBold
OpenInfoFrame.Text = "›"
OpenInfoFrame.TextColor3 = Color3.fromRGB(240, 240, 240)
OpenInfoFrame.TextSize = 20
OpenInfoFrame.MouseButton1Click:Connect(function()
    if not InfoFrame.Visible then
        mainFrame.Size = UDim2.new(0, 565, 0, 35)
        OpenInfoFrame.Text = "‹"
    elseif RemoteScrollFrame.Visible then
        mainFrame.Size = UDim2.new(0, 207, 0, 35)
        OpenInfoFrame.Text = "›"
    end
    InfoFrame.Visible = not InfoFrame.Visible
    InfoFrameOpen = not InfoFrameOpen
end)

Minimize.Name = "Minimize"
Minimize.Parent = mainFrame
Minimize.BackgroundColor3 = colorSettings["Main"]["HeaderColor"]
Minimize.BorderColor3 = colorSettings["Main"]["HeaderColor"]
Minimize.Position = UDim2.new(0, 164, 0, 2)
Minimize.Size = UDim2.new(0, 22, 0, 22)
Minimize.ZIndex = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Text = "_"
Minimize.TextColor3 = Color3.fromRGB(240, 240, 240)
Minimize.TextSize = 20
Minimize.MouseButton1Click:Connect(function()
    if RemoteScrollFrame.Visible then
        mainFrame.Size = UDim2.new(0, 207, 0, 35)
        OpenInfoFrame.Text = "›"
        InfoFrame.Visible = false
    else
        if InfoFrameOpen then
            mainFrame.Size = UDim2.new(0, 565, 0, 35)
            OpenInfoFrame.Text = "›"
            InfoFrame.Visible = true
        else
            mainFrame.Size = UDim2.new(0, 207, 0, 35)
            OpenInfoFrame.Text = "›"
            InfoFrame.Visible = false
        end
    end
    RemoteScrollFrame.Visible = not RemoteScrollFrame.Visible
end)

mouse.KeyDown:Connect(function(key)
    if key:lower() == settings["Keybind"]:lower() then
        ArabSpyGUI.Enabled = not ArabSpyGUI.Enabled
    end
end)

local function FindRemote(remote, args)
    local currentId = (get_thread_context or syn.get_thread_identity)()
    (set_thread_context or syn.set_thread_identity)(7)
    local i
    if table.find(unstacked, remote) then
        local numOfRemotes = 0
        for b, v in pairs(remotes) do
            if v == remote then
                numOfRemotes = numOfRemotes + 1
                for i2, v2 in pairs(remoteArgs) do
                    if table.unpack(remoteArgs[b]) == table.unpack(args) then
                        i = b
                    end
                end
            end
        end
    else
        i = table.find(remotes, remote)
    end
    (set_thread_context or syn.set_thread_identity)(currentId)
    return i
end

local function ButtonEffect(textlabel, text)
    if not text then text = "Copied!" end
    local orgText = textlabel.Text
    local orgColor = textlabel.TextColor3
    textlabel.Text = text
    textlabel.TextColor3 = colorSettings["MainButtons"]["SuccessColor"]
    wait(0.8)
    textlabel.Text = orgText
    textlabel.TextColor3 = orgColor
end

local lookingAt
local lookingAtArgs
local lookingAtButton

CopyCode.MouseButton1Click:Connect(function()
    if not lookingAt then return end
    setclipboard(CodeComment.Text.. "\n\n"..Code.Text)
    ButtonEffect(CopyCode)
end)

RunCode.MouseButton1Click:Connect(function()
    if lookingAt then
        if isA(lookingAt, "RemoteFunction") then
            lookingAt:InvokeServer(unpack(lookingAtArgs))
        elseif isA(lookingAt, "RemoteEvent") then
            lookingAt:FireServer(unpack(lookingAtArgs))
        end
    end
end)

CopyScriptPath.MouseButton1Click:Connect(function()
    local remote = FindRemote(lookingAt, lookingAtArgs)
    if remote and lookingAt then
        setclipboard(GetFullPathOfAnInstance(remoteScripts[remote]))
        ButtonEffect(CopyScriptPath)
    end
end)

local decompiling
CopyDecompiled.MouseButton1Click:Connect(function()
    local remote = FindRemote(lookingAt, lookingAtArgs)
    if not isSynapse() then
        CopyDecompiled.Text = "This exploit doesn't support decompilation!"
        CopyDecompiled.TextColor3 = colorSettings["MainButtons"]["ErrorColor"]
        wait(1.6)
        CopyDecompiled.Text = "Copy decompiled script"
        CopyDecompiled.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        return
    end
    if not decompiling and remote and lookingAt then
        decompiling = true
        spawn(function()
            while true do
                if decompiling == false then return end
                CopyDecompiled.Text = "Decompiling."
                wait(0.8)
                if decompiling == false then return end
                CopyDecompiled.Text = "Decompiling.."
                wait(0.8)
                if decompiling == false then return end
                CopyDecompiled.Text = "Decompiling..."
                wait(0.8)
            end
        end)
        local success = { pcall(function()setclipboard(decompile(remoteScripts[remote]))end) }
        decompiling = false
        if success[1] then
            CopyDecompiled.Text = "Copied decompilation!"
            CopyDecompiled.TextColor3 = colorSettings["MainButtons"]["SuccessColor"]
        else
            warn(success[2], success[3])
            CopyDecompiled.Text = "Decompilation error! Check F9 to see the error."
            CopyDecompiled.TextColor3 = colorSettings["MainButtons"]["ErrorColor"]
        end
        wait(1.6)
        CopyDecompiled.Text = "Copy decompiled script"
        CopyDecompiled.TextColor3 = colorSettings["MainButtons"]["TextColor"]
    end
end)

BlockRemote.MouseButton1Click:Connect(function()
    local bRemote = table.find(BlockList, lookingAt)
    if lookingAt and not bRemote then
        table.insert(BlockList, lookingAt)
        BlockRemote.Text = "Unblock remote"
        BlockRemote.TextColor3 = colorSettings["MainButtons"]["WarningColor"]
        local remote = table.find(remotes, lookingAt)
        if remote then
            remoteButtons[remote].Parent.RemoteName.TextColor3 = colorSettings["MainButtons"]["WarningColor"]
        end
    elseif lookingAt and bRemote then
        table.remove(BlockList, bRemote)
        BlockRemote.Text = "Block remote from firing"
        BlockRemote.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        local remote = table.find(remotes, lookingAt)
        if remote then
            remoteButtons[remote].Parent.RemoteName.TextColor3 = colorSettings["RemoteButtons"]["TextColor"]
        end
    end
end)

IgnoreRemote.MouseButton1Click:Connect(function()
    local iRemote = table.find(IgnoreList, lookingAt)
    if lookingAt and not iRemote then
        table.insert(IgnoreList, lookingAt)
        IgnoreRemote.Text = "Stop ignoring remote"
        IgnoreRemote.TextColor3 = Color3.fromRGB(150, 150, 150)
        local remote = table.find(remotes, lookingAt)
        local unstacked = table.find(unstacked, lookingAt)
        if remote then
            remoteButtons[remote].Parent.RemoteName.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    elseif lookingAt and iRemote then
        table.remove(IgnoreList, iRemote)
        IgnoreRemote.Text = "Ignore remote"
        IgnoreRemote.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        local remote = table.find(remotes, lookingAt)
        if remote then
            remoteButtons[remote].Parent.RemoteName.TextColor3 = colorSettings["RemoteButtons"]["TextColor"]
        end
    end
end)

WhileLoop.MouseButton1Click:Connect(function()
    if not lookingAt then return end
    setclipboard("while wait() do\n   "..Code.Text.."\nend")
    ButtonEffect(WhileLoop)
end)

Clear.MouseButton1Click:Connect(function()
    for i, v in pairs(RemoteScrollFrame:GetChildren()) do
        if i > 1 then v:Destroy() end
    end
    for i, v in pairs(connections) do
        v:Disconnect()
    end
    buttonOffset = -25
    scrollSizeOffset = 0
    remotes = {}
    remoteArgs = {}
    remoteButtons = {}
    remoteScripts = {}
    IgnoreList = {}
    BlockList = {}
    IgnoreList = {}
    RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 287)
    unstacked = {}
    connections = {}
    ButtonEffect(Clear, "Cleared!")
end)

DoNotStack.MouseButton1Click:Connect(function()
    if lookingAt then
        local isUnstacked = table.find(unstacked, lookingAt)
        if isUnstacked then
            table.remove(unstacked, isUnstacked)
            DoNotStack.Text = "Unstack remote when fired with new args"
            DoNotStack.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        else
            table.insert(unstacked, lookingAt)
            DoNotStack.Text = "Stack remote"
            DoNotStack.TextColor3 = colorSettings["MainButtons"]["WarningColor"]
        end
    end
end)

local function len(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

local function convertTableToString(args)
    local string = ""
    local index = 1
    for i,v in pairs(args) do
        if type(i) == "string" then
            string = string .. '["' .. tostring(i) .. '"] = '
        elseif type(i) == "userdata" and typeof(i) ~= "Instance" then
            string = string .. "[" .. typeof(i) .. ".new(" .. tostring(i) .. ")] = "
        elseif type(i) == "userdata" then
            string = string .. "[" .. GetFullPathOfAnInstance(i) .. "] = "
        end
        if v == nil then
            string = string ..  "nil"
        elseif typeof(v) == "Instance"  then
            string = string .. GetFullPathOfAnInstance(v)
        elseif type(v) == "number" or type(v) == "function" then
            string = string .. tostring(v)
        elseif type(v) == "userdata" then
            string = string .. typeof(v)..".new("..tostring(v)..")"
        elseif type(v) == "string" then
            string = string .. [["]]..v..[["]]
        elseif type(v) == "table" then
            string = string .. "{"
            string = string .. convertTableToString(v)
            string = string .. "}"
        elseif type(v) == 'boolean' then
            if v then
                string = string..'true'
            else
                string = string..'false'
            end
        end
        if len(args) > 1 and index < len(args) then
            string =  string .. ","
        end
        index = index + 1
    end
    return string
end

CopyReturn.MouseButton1Click:Connect(function()
    local remote = FindRemote(lookingAt, lookingAtArgs)
    if lookingAt and remote then
        if isA(lookingAt, "RemoteFunction") then
            local result = remotes[remote]:InvokeServer(unpack(remoteArgs[remote]))
            setclipboard(convertTableToString(table.pack(result)))
            ButtonEffect(CopyReturn)
        end
    end
end)

RemoteScrollFrame.ChildAdded:Connect(function(child)
    local remote = remotes[#remotes]
    local args = remoteArgs[#remotes]
    local event = true
    local fireFunction = ":FireServer("
    if isA(remote, "RemoteFunction") then
        event = false
        fireFunction = ":InvokeServer("
    end
    local connection = child.MouseButton1Click:Connect(function()
        InfoHeaderText.Text = "Info: "..remote.Name
        if event then 
            InfoButtonsScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
        else
            InfoButtonsScroll.CanvasSize = UDim2.new(0, 0, 1.1, 0)
        end
        mainFrame.Size = UDim2.new(0, 565, 0, 35)
        OpenInfoFrame.Text = "›"
        InfoFrame.Visible = true
        Code.Text = GetFullPathOfAnInstance(remote)..fireFunction..convertTableToString(args)..")"
        local textsize = TextService:GetTextSize(Code.Text, Code.TextSize, Code.Font, Vector2.new(math.huge, math.huge))
        CodeFrame.CanvasSize = UDim2.new(0, textsize.X + 11, 2, 0)
        lookingAt = remote
        lookingAtArgs = args
        lookingAtButton = child.Number
        local blocked = table.find(BlockList, remote)
        if blocked then
            BlockRemote.Text = "Unblock remote"
            BlockRemote.TextColor3 = colorSettings["MainButtons"]["WarningColor"]
        else
            BlockRemote.Text = "Block remote from firing"
            BlockRemote.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        end
        local iRemote = table.find(IgnoreList, lookingAt)
        if iRemote then
            IgnoreRemote.Text = "Stop ignoring remote"
            IgnoreRemote.TextColor3 = Color3.fromRGB(150, 150, 150)
        else
            IgnoreRemote.Text = "Ignore remote"
            IgnoreRemote.TextColor3 = colorSettings["MainButtons"]["TextColor"]
        end
        InfoFrameOpen = true
    end)
    table.insert(connections, connection)
end)

local function addToList(event, remote, ...)
    local currentId = (get_thread_context or syn.get_thread_identity)()
    (set_thread_context or syn.set_thread_identity)(7)
    if not remote then return end
    local name = remote.Name
    local args = {...}
    local i = FindRemote(remote, args)
    if not i then
        table.insert(remotes, remote)
        local rButton = clone(RemoteButton)
        remoteButtons[#remotes] = rButton.Number
        remoteArgs[#remotes] = args
        remoteScripts[#remotes] = (isSynapse() and getcallingscript() or rawget(getfenv(0), "script"))
        rButton.Parent = RemoteScrollFrame
        rButton.Visible = true
        local numberTextsize = getTextSize(TextService, rButton.Number.Text, rButton.Number.TextSize, rButton.Number.Font, Vector2.new(math.huge, math.huge))
        rButton.RemoteName.Position = UDim2.new(0,numberTextsize.X + 10, 0, 0)
        if name then
            rButton.RemoteName.Text = name
        end
        if not event then
            rButton.RemoteIcon.Image = functionImage
        end
        buttonOffset = buttonOffset + 35
        rButton.Position = UDim2.new(0.091, 0, 0, buttonOffset)
        if #remotes > 8 then
            scrollSizeOffset = scrollSizeOffset + 35
            RemoteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollSizeOffset)
        end
    else
        remoteButtons[i].Text = tostring(tonumber(remoteButtons[i].Text) + 1)
        local numberTextsize = getTextSize(TextService, remoteButtons[i].Text, remoteButtons[i].TextSize, remoteButtons[i].Font, Vector2.new(math.huge, math.huge))
        remoteButtons[i].Parent.RemoteName.Position = UDim2.new(0,numberTextsize.X + 10, 0, 0)
        remoteButtons[i].Parent.RemoteName.Size = UDim2.new(0, 149 -numberTextsize.X, 0, 26)
        remoteArgs[i] = args
        if lookingAt and lookingAt == remote and lookingAtButton == remoteButtons[i] and InfoFrame.Visible then
            local fireFunction = ":FireServer("
            if isA(remote, "RemoteFunction") then
                fireFunction = ":InvokeServer("
            end
            Code.Text = GetFullPathOfAnInstance(remote)..fireFunction..convertTableToString(remoteArgs[i])..")"
            local textsize = getTextSize(TextService, Code.Text, Code.TextSize, Code.Font, Vector2.new(math.huge, math.huge))
            CodeFrame.CanvasSize = UDim2.new(0, textsize.X + 11, 2, 0)
        end
    end
    (set_thread_context or syn.set_thread_identity)(currentId)
end

local OldEvent
OldEvent = hookfunction(Instance.new("RemoteEvent").FireServer, function(Self, ...)
    if not checkcaller() and table.find(BlockList, Self) then
        return
    elseif table.find(IgnoreList, Self) then
        return OldEvent(Self, ...)
    end
    addToList(true, Self, ...)
end)

local OldFunction
OldFunction = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(Self, ...)
    if not checkcaller() and table.find(BlockList, Self) then
        return
    elseif table.find(IgnoreList, Self) then
        return OldFunction(Self, ...)
    end
    addToList(false, Self, ...)
end)

local OldNamecall
OldNamecall = hookmetamethod(game,"__namecall",function(...)
    local args = {...}
    local Self = args[1]
    local method = (getnamecallmethod or get_namecall_method)()
    if method == "FireServer" and isA(Self, "RemoteEvent")  then
        if not checkcaller() and table.find(BlockList, Self) then
            return
        elseif table.find(IgnoreList, Self) then
            return OldNamecall(...)
        end
        addToList(true, ...)
    elseif method == "InvokeServer" and isA(Self, 'RemoteFunction') then
        if not checkcaller() and table.find(BlockList, Self) then
            return
        elseif table.find(IgnoreList, Self) then
            return OldNamecall(...)
        end
        addToList(false, ...)
    end
    return OldNamecall(...)
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(...)
    local args = {...}
    local Self = args[1]
    local method = (getnamecallmethod or get_namecall_method)()
    
    if method == "FireServer" and isA(Self, "RemoteEvent") then
        if not checkcaller() and table.find(BlockList, Self) then
            return
        elseif table.find(IgnoreList, Self) then
            return OldNamecall(...)
        end
        addToList(true, Self, select(2, ...))
    elseif method == "InvokeServer" and isA(Self, "RemoteFunction") then
        if not checkcaller() and table.find(BlockList, Self) then
            return
        elseif table.find(IgnoreList, Self) then
            return OldNamecall(...)
        end
        addToList(false, Self, select(2, ...))
    end
    
    return OldNamecall(...)
end)