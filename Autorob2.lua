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
    local steps = 100 -- Number of steps for smoother teleportation
    local currentPosition = hrp.Position
    local stepSize = (targetPosition - currentPosition) / steps

    for i = 1, steps do
        hrp.Position = hrp.Position + stepSize
        wait(1.05) -- Adjust speed of teleportation
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPosition)
end

-- Loop through all children in workspace.ObjectSelection
for _, object in pairs(workspace.ObjectSelection:GetChildren()) do
    if object:FindFirstChild("Cash") and object.Cash:FindFirstChild("Cash") then
        local cashModel = object.Cash
        local cashEvent = cashModel.Cash:FindFirstChild("Event")

        -- Check if the event exists and is a RemoteEvent
        if cashEvent and cashEvent:IsA("RemoteEvent") then
            -- Get the position of the Cash model or one of its parts
            local targetPosition = cashModel:FindFirstChild("PrimaryPart") and cashModel.PrimaryPart.Position or cashModel.Position
            
            -- Teleport to the Cash object and fire its event
            smoothTeleportTo(targetPosition) -- Teleport to the Cash object
            wait(0.5) -- Wait a moment after teleporting
            cashEvent:FireServer()
            print("Fired Cash event at:", object.Name)
        else
            print("Cash event not found in:", object.Name)
        end
    end
end

print("Finished firing all Cash events.")
