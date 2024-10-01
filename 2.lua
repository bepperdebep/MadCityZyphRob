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

    -- Anchor HumanoidRootPart to avoid falling
    hrp.Anchored = true

    for i = 1, steps do
        hrp.CFrame = hrp.CFrame + CFrame.new(stepSize)
        wait(0.05) -- Adjust speed of teleportation
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPosition)
    
    -- Unanchor after reaching the destination
    wait(0.5)
    hrp.Anchored = false
end

-- Function to handle Cash objects
local function handleCashObject(object)
    if object:FindFirstChild("Cash") and object.Cash:FindFirstChild("Cash") then
        local cashModel = object.Cash
        local cashEvent = cashModel.Cash:FindFirstChild("Event")

        -- Check if the event exists and is a RemoteEvent
        if cashEvent and cashEvent:IsA("RemoteEvent") then
            -- Get the position of the Cash model
            local targetPosition = cashModel.Position
            
            -- Enable noclip during teleport to avoid walls
            noclip = true
            smoothTeleportTo(targetPosition) -- Teleport to the Cash object
            noclip = false -- Disable noclip after reaching
            
            wait(0.5) -- Wait a moment after teleporting
            cashEvent:FireServer()
            print("Fired Cash event at:", object.Name)
        else
            print("Cash event not found in:", object.Name)
        end
    end
end

-- Function to handle SmashCash objects
local function handleSmashCashObject(object)
    if object:FindFirstChild("SmashCash") then
        local smashCashModel = object.SmashCash
        -- Look for another SmashCash inside
        if smashCashModel:FindFirstChild("SmashCash") then
            local innerSmashCash = smashCashModel.SmashCash
            local smashEvent = innerSmashCash:FindFirstChild("Event")
            
            -- Check if the event exists and is a RemoteEvent
            if smashEvent and smashEvent:IsA("RemoteEvent") then
                -- Get the position of the SmashCash model
                local targetPosition = smashCashModel.Position

                -- Enable noclip during teleport
                noclip = true
                smoothTeleportTo(targetPosition) -- Teleport to the SmashCash object
                noclip = false -- Disable noclip after reaching
                
                wait(0.5) -- Wait a moment after teleporting
                smashEvent:FireServer()
                print("Fired SmashCash event at:", object.Name)
            else
                print("SmashCash event not found in:", object.Name)
            end
        end
    end
end

-- Loop through all children in workspace.ObjectSelection
for _, object in pairs(workspace.ObjectSelection:GetChildren()) do
    -- Handle "Cash" objects
    if object:FindFirstChild("Cash") then
        handleCashObject(object)
    end
    
    -- Handle "SmashCash" objects
    if object:FindFirstChild("SmashCash") then
        handleSmashCashObject(object)
    end
end

print("Finished firing all Cash and SmashCash events.")
