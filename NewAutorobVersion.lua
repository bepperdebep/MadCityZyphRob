-- List of target objects to search for
local targetObjects = {
    "Cash",
    "CashRegister",
    "DiamondBox",
    "Laptop",
    "Phone",
    "Luggage",
    "ATM",
    "TV",
    "Safe"
}

-- Function to search for objects in the workspace
function searchForObjects()
    local foundObjects = {}
    for _, objectName in ipairs(targetObjects) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == objectName then
                table.insert(foundObjects, obj)
            end
        end
    end
    return foundObjects
end

-- Function to "fly" to a target position using CFrame manipulation
function flyToPosition(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Define fly speed and step increments
    local flySpeed = 100
    while (humanoidRootPart.Position - position).magnitude > 5 do
        -- Move smoothly towards the target position using CFrame
        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(CFrame.new(position), 0.1)
        wait(0.05)
    end
end

-- Function to trigger RemoteEvent when at the object using FireServer
function triggerEvent(object)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Loop through all descendants to find RemoteEvent
    for _, descendant in pairs(object:GetDescendants()) do
        if descendant:IsA("RemoteEvent") and descendant.Parent:IsA("Part") then
            -- Check if the player is close enough to the object (within 20 studs)
            if (humanoidRootPart.Position - descendant.Parent.Position).magnitude < 20 then
                -- Trigger the RemoteEvent
                descendant:FireServer()
                print("Triggered RemoteEvent for: " .. object.Name)
            end
        end
    end
end

-- Main loop to search, fly, and trigger events
local objects = searchForObjects()
for _, obj in ipairs(objects) do
    print("Found object: " .. obj.Name)
    flyToPosition(obj.Position)  -- Fly to the object's position

    wait(1)  -- Wait at the object for a second

    triggerEvent(obj)  -- Trigger any event associated with the object
end
