-- Get the Local Player and HumanoidRootPart
local lp = game.Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Noclip function to allow passing through walls
local runService = game:GetService("RunService")
local noclip = true
runService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Teleport function
local function teleportToPart(targetPart)
    hrp.CFrame = targetPart.CFrame
    print("Teleported to", targetPart.Name)
end

-- Fire RemoteEvent function
local function fireNestedRemoteEvent(smashCashPart)
    -- Access the nested SmashCash object and its RemoteEvent
    local nestedSmashCash = smashCashPart:FindFirstChild("SmashCash") -- Find the nested SmashCash
    if nestedSmashCash then
        local cashEvent = nestedSmashCash:FindFirstChild("Cash") and nestedSmashCash.Cash:FindFirstChild("Cash") and nestedSmashCash.Cash.Cash.Event
        
        -- Check if the event exists and is a RemoteEvent
        if cashEvent and cashEvent:IsA("RemoteEvent") then
            -- Fire the RemoteEvent
            cashEvent:FireServer()
            print("Fired Cash event inside", nestedSmashCash.Name)
        else
            print("Cash event not found inside", nestedSmashCash.Name)
        end
    else
        print("No nested SmashCash found inside", smashCashPart.Name)
    end
end

-- Target SmashCash part
local targetPart = workspace.ObjectSelection:GetChildren()[231] -- Change the index as needed

-- Check if the target part is valid
if targetPart and targetPart:IsA("Part") and targetPart.Name == "SmashCash" then
    -- Teleport to the SmashCash part
    teleportToPart(targetPart)
    
    -- Wait a moment after teleporting
    wait(0.5) -- Adjust the wait time if needed

    -- Fire the nested RemoteEvent after teleporting
    fireNestedRemoteEvent(targetPart)
else
    print("Target SmashCash part is invalid or not found.")
end
