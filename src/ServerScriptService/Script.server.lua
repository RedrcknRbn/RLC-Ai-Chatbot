local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local ChatService = game:GetService("Chat")

local ChatServiceModule = require(ServerScriptService:WaitForChild("ChatServiceRunner").ChatService) -- Assuming LegacyChat exists. I honestly dont know how to use new chatservice

local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent" -- Gemini 1.0 Pro API. I got access to 1.5, but they aren't letting us implement 1.5 into full scale applications yet
--local generating = false

local bot =  ChatServiceModule:AddSpeaker("HelperDrone")
bot:SetExtraData("NameColor", Color3.new(0.666667, 1, 1))
bot:JoinChannel("All")

function decipherText(text)

	local decoded = HttpService:JSONDecode(text)

	local function fail()
		print(decoded)
		print("failed")
		return "fail"
	end

	if decoded["candidates"] then -- google why do you force me to do this ugliness
		if decoded["candidates"][1]["content"]["parts"][1]["text"] then
			return decoded["candidates"][1]["content"]["parts"][1]["text"]
		else
			fail()
		end
	elseif decoded["contents"] then
		if decoded["contents"][1]["parts"][1]["text"] then
			return decoded["contents"][1]["parts"][1]["text"]
		else
			fail()
		end
	elseif decoded["promptFeedback"] then
		fail()
	else
		fail()
	end
end

local header = {
	["x-goog-api-key"] = "KEY_HERE"
}

function Generate(msg:string)

	print(msg)

	if msg then

		local function RequestResponse(msg2)

			local body

			body = HttpService:JSONEncode({
				contents = {{
					role = "user",
					parts = {{ -- knowledgebase
						text = [[You are a Staff Member of a Roblox Library. You are to help people with any queries they may have.
						Here are some questions that have been asked and answered before:
						How do I make a book,"You can either PM one of our Librarians or join the Communications Server that's attached to the group."
Is there a minimum/maximum word count for books,"No, there is no minimum/maximum word count."
How long does it take for my book to be reviewed,"A book can take up to 3 months to be reviewed and added to the library. We go through a lengthy process to add it."
Can I submit multiple books at the same time,"Yes, you can submit multiple books at the same time."
How can I add pictures to my book,"They must be decals uploaded on Roblox with copying allowed. Just include the decal link in your story where you want the picture to be. "
How do I become a staff member,"Check our Communications Server on updates for open Staff positions"
How do I join your Communications Server,"The button to join our Communications Server is on our group."
Can I publish a book from real life,"No, we do not accept real books because it would be plagiarizing. Books must be at least 50% original content and all external sources must be credited."
What is the Communications Server?,"The Communications Server is an Offsite Server where our Community is."
How do I find a specific book,"You can find a book by using our book search feature in the upper right hand corner. It looks like a magnifying glass!"
What does a librarian do,"A Librarian turns the stuff people write into actual books for the Library"
What does a secretary do,"Secretaries are Staff members responsible for moderating the library game, group wall, and Communications Server."
How do I get notified for events or game updates,"Please join our Communications Server to stay up-to-date on all things library related!"
What is Contributor rank,"Anyone who has donated at least 250 Robux will be rewarded Contributor."
What is Contest Winner rank,"Anyone who has won a contest, hosted by our Community Events Specialist or other staff members."
What is Author rank,"Anyone who has published a book in ROBLOX Library will be rewarded with this rank."
I made a book, but I dont have Author rank,"If you see your book in the library (or in a workshop) and need to get ranked, message a staff member!"
What is Award Winning Author rank,"Anyone who has published a book in ROBLOX Library and has won the Book of the Month contest will receive this rank."
What does Review Committee do,"Review Committee is a volunteer, non-staff role for our Communications Server only. Members of the Review Committee are responsible for reviewing books to make sure they abide with ROBLOX’s ToU/Community Roles."
What is Veteran rank,"Veterans are former staff members at ROBLOX Library who resigned."
What is Intern rank,"Interns are secretaries-in-training"
What is Librarian in Training rank,"Librarians in Training are librarians who are training to make books."
What is Administrative Staff rank,"Administrative Staff are staff members who have shown dedication and contribution while they are were a Librarian or Secretary. Administrative Staff members also include Head Librarian and Head Secretary, who are responsible for overseeing the two teams, as well as our Book Movers."
What is a Book Mover,"A book mover is someone who moves books Librarians make into the Library"
What is Connected Partner rank,"Connected Partners are partners from an allied group."
What is Retired Management rank,"Staff that are Retired Management are former Library Managers"
What is Manager Apprentice rank,"Manager Apprentices are Staff members who are Library Managers in training."
What is Library Manager rank,"Library Managers are the people in charge of running the Library. There are also sub-jobs that help us run the library more efficiently."
What is The Ancients rank,"The Ancients are the founders and former Master Librarians of the Library"
What is Master Librarian rank,"Master Librarians are the owners of the Library, who oversee the development and operations of the group."
What is Library Overseer rank,"The Library Overseer rank is reserved for the account that holds the group."
What staff ranks can I apply for,"The staff and volunteer jobs you can apply for are Secretary, Librarian, Review Committee, Quality Control Team, Builder, GFX/UI Designer, Scripter, Voice Actor, and Library Post Editor"
What does Quality Control Team do,"The Quality Control Team (QCT) help make sure that books are up to standards for the Library."
What do builders do,"Builders help keep the Library's design up to date"
What do GFX/UI Designers do,"They help make either UI for the Library, or promotional material for the Library"
What do Scripters do,"They help keep the Library running by making sure everything behind the scenes is working"
What do Voice Actors do,"Voice Actors narrarate our Audio Books"
What is the Library Post,"The Library Post is a Newsletter ingame of-sorts. They make 'articles' that recommend books!"
What do Library Post Editors do,"They write editions of the Library Post",
How do I apply for a volunteer position,"Check our Communications Server on updates for open Volunteer positions"
What are the ranks in the group, highest to lowest,"Library Overseer, Master Librarian, The Ancients, Library Manager, Manager Apprentice, Retired Management, Administrative Staff, Connected Partner, Developer, Librarian, Librarian-In-Training, Secretary, Intern, Veteran, Award Winning Author, Contest Winner, Contributor, Author, Reader"
What are the Staff Ranks, highest to lowest,"Master Librarian, The Ancients, Library Manager, Manager Apprentice, Head Librarian, Head Secretary, Head of Community, Administrative Staff, Senior Librarian, Senior Secretary, Librarian, Librarian In Training, Secretary, Intern, Retired Management, Veteran"
What does Senior Librarian do,"Senior Librarians are Higher Ranking Librarians"
What does Senior Secretary do,"Senior Secretaries are Higher Ranking Secretaries"
What does Head Librarian do,"The Head Librarian is in charge of the Librarians"
What does Head Secretary do,"The Head Secretary is in charge of the Secretaries"
What does Head of Community do,"The Head of Community is in charge of all Community Events"
What Library Post Ranks are there,"From Highest to Lowest ranking, the Library Post Ranks are: Library Post Director, Library Post Deputy Director, Library Post Editor"

Use these questions and answers to help you answer any queries given
						Someone just asked you a question, they just asked: ]]..msg2
					}}
				}},
				generationConfig = {
					temperature = 0,
					topK = 1,
					topP = 1,
					max_output_tokens = 50, -- *should* limit to less than 200 characters, 1 token roughly equal to 4 characters
				},
				safetySettings = { -- show only allow the CLEANEST messages
					{
						category = "HARM_CATEGORY_HARASSMENT",
						threshold = "BLOCK_LOW_AND_ABOVE"
					},
					{
						category = "HARM_CATEGORY_HATE_SPEECH",
						threshold = "BLOCK_LOW_AND_ABOVE"
					},
					{
						category = "HARM_CATEGORY_SEXUALLY_EXPLICIT",
						threshold = "BLOCK_LOW_AND_ABOVE"
					},
					{
						category = "HARM_CATEGORY_DANGEROUS_CONTENT",
						threshold = "BLOCK_LOW_AND_ABOVE"
					}
				}
			})

			local content
			local author
			local message

			local success, err = pcall(function()
				print(HttpService:JSONDecode(body))
				local response = HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson, nil, header) 

				message = decipherText(response)

			end)
			if err then
				print(script.Name.." Failed HTTP, ERROR: "..err)
				return "fail"
			else
				return(message)
			end
		end
		
		local function IsQuestion(msg2)
			local body

			body = HttpService:JSONEncode({ 
				contents = {{
					role = "user",
					parts = {{
						text = [[Your job is to determine if someone is asking a question to a Staff Member of a Library's Chat Room.
						If it is a Question, say "yes", if it isn't a question, say "no".
						You are ONLY to say YES or NO. Do not say anything else.
						Here is the message:]]..msg2
					}}
				}},
				generationConfig = {
					temperature = 0,
					topK = 1,
					topP = 1,
					max_output_tokens = 2,
				},
				safetySettings = { -- so safety doesnt mess with it
					{
						category = "HARM_CATEGORY_HARASSMENT",
						threshold = "BLOCK_NONE"
					},
					{
						category = "HARM_CATEGORY_HATE_SPEECH",
						threshold = "BLOCK_NONE"
					},
					{
						category = "HARM_CATEGORY_SEXUALLY_EXPLICIT",
						threshold = "BLOCK_NONE"
					},
					{
						category = "HARM_CATEGORY_DANGEROUS_CONTENT",
						threshold = "BLOCK_NONE"
					}
				}
			})

			local content
			local author
			local message

			local success, err = pcall(function()
				print(HttpService:JSONDecode(body))
				local response = HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson, nil, header) -- Sends a POST request to the OpenAI API endpoint with the request body and authentication header, and receives the API response. Don't change this if you don't know what you are doing.

				message = decipherText(response)

			end)
			if err then
				print(script.Name.." Failed HTTP, ERROR: "..err)
				return(false)
			else
				if string.find(message,"yes") then
					return(true)
				else
					return(false)
				end
			end
		end

		if IsQuestion(msg) then -- Checks to see if the message is a question
			local response:string = RequestResponse(msg)
			print(response)
			bot:SayMessage(response, "All")
		end
	end

end

game:GetService("Players").PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(msg)
		--if generating == false then
			Generate(msg)
		--end
	end)
end)