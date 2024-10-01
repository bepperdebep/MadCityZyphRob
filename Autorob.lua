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

-- Function to smoothly teleport to specified coordinates
local function smoothTeleportTo(targetPosition)
    local steps = 25 -- Number of steps for smoother teleportation
    local currentPosition = hrp.Position
    local stepSize = (targetPosition - currentPosition) / steps

    for i = 1, steps do
        hrp.Position = hrp.Position + stepSize
        wait(0.05) -- Adjust speed of teleportation
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPosition)
end

-- Target coordinates
local targetPosition = Vector3.new(1557.40185546875, 24.229877471923828, 1253.985107421875)

-- Teleport to the specified coordinates
smoothTeleportTo(targetPosition)

-- Wait a moment after teleporting
wait(0.5) -- Adjust the wait time if needed

-- Access the specific RemoteEvent inside the Cash object
local cashEvent = workspace.ObjectSelection:GetChildren()[136].Cash:FindFirstChild("Cash") and workspace.ObjectSelection:GetChildren()[136].Cash.Cash:FindFirstChild("Event")

-- Check if the event exists and is a RemoteEvent
if cashEvent and cashEvent:IsA("RemoteEvent") then
    -- Fire the RemoteEvent
    cashEvent:FireServer()
    print("Fired Cash event.")
else
    print("Cash event not found.")
end
