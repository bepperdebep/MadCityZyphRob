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

-- Function to smoothly teleport to a target part
local function smoothTeleportTo(targetPart)
    local steps = 25 -- Number of steps for smoother teleportation
    local targetPosition = targetPart.Position
    local currentPosition = hrp.Position
    local stepSize = (targetPosition - currentPosition) / steps

    for i = 1, steps do
        hrp.Position = hrp.Position + stepSize
        wait(0.05) -- Adjust speed of teleportation
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPosition)
end

-- Target the specific Cash object
local targetObject = workspace.ObjectSelection:GetChildren()[136].Cash

-- Check if the target object is valid
if targetObject and targetObject:IsA("Part") then
    -- Teleport to the Cash object
    smoothTeleportTo(targetObject)
    
    -- Wait a moment after teleporting
    wait(0.5) -- Adjust the wait time if needed

    -- Fire the RemoteEvent inside Cash
    local cashEvent = targetObject:FindFirstChild("Cash") and targetObject.Cash:FindFirstChild("Event")
    if cashEvent and cashEvent:IsA("RemoteEvent") then
        cashEvent:FireServer()
        print("Fired Cash event inside", targetObject.Name)
    else
        print("Cash event not found inside", targetObject.Name)
    end
else
    print("Target Cash object is invalid or not found.")
end
