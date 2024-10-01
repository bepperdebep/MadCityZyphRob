-- Get the Local Player and HumanoidRootPart
local lp = game.Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Noclip function to allow passing through walls (disabled for now)
local runService = game:GetService("RunService")
local noclip = false
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
    local steps = 25 -- Increase the number of steps to make the teleport smoother
    local currentPosition = hrp.Position
    local stepSize = (targetPosition - currentPosition) / steps

    for i = 1, steps do
        hrp.Position = hrp.Position + stepSize
        wait(0.05) -- Increase speed of steps if needed
    end

    -- Ensure the player is at the exact target position
    hrp.CFrame = CFrame.new(targetPosition)
end

-- Function to handle Cash objects
local function handleCashObject(object)
    if object:FindFirstChild("Cash") and object.Cash:FindFirstChild("Cash") then
        local cashModel = object.Cash
        local cashEvent = cashModel.Cash:FindFirstChild("Event")

        -- Check if the event exists and is a RemoteEvent
        if cashEvent and cashEvent:IsA("RemoteEvent") then
            -- Get the position of the Cash model or one of its parts
            local targetPosition = cashModel:FindFirstChild("PrimaryPart") and cashModel.PrimaryPart.Position or cashModel.Position
            
            -- Smoothly teleport to the Cash object and fire its event
            smoothTeleportTo(targetPosition) -- Smooth teleport to the Cash object
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
                -- Get the position of the SmashCash model or one of its parts
                local targetPosition = smashCashModel:FindFirstChild("PrimaryPart") and smashCashModel.PrimaryPart.Position or smashCashModel.Position

                -- Smoothly teleport to the SmashCash object and fire its event
                smoothTeleportTo(targetPosition) -- Smooth teleport to the SmashCash object
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
