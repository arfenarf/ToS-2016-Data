library(httr)
library(jsonlite)

# at the moment, it's being baulky and only returning 10 records.
# why this works in Postman and not here is a mystery.  So I'm just
# grabbing files from Postman by hand from now.

address = "https://www.trainerroad.com/api/rides"

payload = "{\"IsDescending\":true,\"PageSize\":3000,\"PageNumber\":0,\"TotalCount\":0,\"SortProperty\":\"Newest\",\"SearchText\":null,\"MinimumTicks\":600,\"MemberId\":null,\"WorkoutId\":null,\"ShowAllText\":\"longer than 10 minutes\",\"ShowAllLinkText\":\"show all\"}"

add_headers(
     accept = '*/*',
     origin = 'https//www.trainerroad.com',
     referer = 'https//www.trainerroad.com/teams/3925-2016-tour-of-sufferlandria/rides',
     'content-type' = 'application/json; charset=UTF-8',
     'user-agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36',
     'accept-encoding' = 'gzip, deflate',
     'accept-language' = 'en-US,en;q=0.8',
     cookie = "optimizelyEndUserId=oeu1454984671030r0.08871188759803772; __RequestVerificationToken=Dmm8T8nFDCYOoLtaZuZqslkgATORsTyEX1O9DkfkQnVaZAQ0Y-Ypn3lvl9RAvdqlH-9eL1wZm3s2NpGzLPG2iAzK6UU9yoz6YLaBnNqDjY41; TrainerRoadAuth=E2F2E1775BF7FA7BC7B9AC88350114770A1DF336682CF8DE731EF7B4A3E48152039A9960AD2132344A1257C14EAA8460493E2EAFF5070F60F376C49C3301D29D96C5AAAA9E215366C9807C1C3BB34789A0E308E5207B9F98B5B6AE451921376A; notification-sync-seen=1; ARRAffinity=7b76b714f2e6288df83a672f884fb10b8ed83c83908e9792be072097b55e0635; arfenarf-settings=units=mph; optimizelySegments=%7B%222774710745%22%3A%22direct%22%2C%222781820595%22%3A%22false%22%2C%222794270093%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.2.623929280.1454984672; _gat=1; __zlcmid=Z6fJa5d2n8Byzo; .ASPXROLES=YOB_BvSAJVqfxMa0Y0BuGeLbNwZGfEdPGdNYJv1F8wDA1fYiZmrazyo-fB0pECR1o4Fe922eSPMdoKDd8f-7tPPJmzDylRAZhrgr6xh8Eq4RWyZ4chk241XiKOo4rte8TbgQ8zj5Ik16D5h5Z5MQD9qkPXJSJWWJA7XKMlvGpJv-SMr10ePqJ4tzKHkNiPgatJtOjYwb6U9hQw78eMpAlBVD-l2OPaXZeW5xS8ERzdGWfqMZWHkiQRTEYdiWHkQx2l_BxW4pYru3dNHY7lKTTQ3-ZNOa7umdtTpfVaaTGwFtAnojh0YehSJlIkxW81w8DuiM7n9oah-IAUD9Cy0URAgrjvWNck6KWOA52AgDK2wEECvHUpxhRo8B4IaUtG4aInfH7eoUDZpyIaPhLh0QJk6D6cL34Rxlhk4VOONdVZkSi_y592uHnAblUPVXYWTslxgQ8H_LHjCP9LXAypR0zweYyRYAX_Ngl04Sctz4fLk1; optimizelyEndUserId=oeu1454984671030r0.08871188759803772; _gat=1; ARRAffinity=7b76b714f2e6288df83a672f884fb10b8ed83c83908e9792be072097b55e0635; __RequestVerificationToken=4NxpsH_F1ZKy9qvXheLYaF1sFP4F1UkzX6hBfA4AZ-TEFaRs4BukF0BZipJ4pVI166KiypAvkTOJMJZELkigMP0C7RNuwBO7CpG_nxKRoqI1; TrainerRoadAuth=01F2825FF5FCAB4675CB71F4F0847992F303D7C0BC2B95951D97B4E13125538A5299DC61F61D1D20CA1943A96FE8EDA3BA17BD8A35995E762948B75FA337CDFF6EAC4E2E94DCD92578AE252830408677AA6A51062B4214CCD2D0C1E2F0002A7C; arfenarf-settings=units=mph; .ASPXROLES=-c38Q1Ol1-DCUEP1q-OtLVpyC8FHbrcG9sxcy5FvuOMKnoe0FpQ-vXhRZAzjIHSifFo6Z3SBFxLMePKB2KKWIDQIqTqjXHkddGueTtOVtL_6qge4e0jFrzxaG_qnzerwRf2zxJklpXgxZG8gAxqiqXg2rLCwipnggILdqzwqX6J48T25yPo_3in4MhStB0yiojGLOHtoLlsEFhp6X6EpKUZVD0KSr3s6NyJ81MRbihU8PyGE-gXYHeUNfscNlpvkuzw3YS0sk2nOw7iS3GHzOPyPaQNpp28icYBkglWE0VYHsUDMEIUt5N7X-AAH13VrbFC8-Nmwr-uXyT3bGJlQKQP-zX4jPzWlc-qawJhaDTqOcRon8YXubB5vbQ1LAqpmsjWLQy0GmpRqjwmEfq8v2b_MU3aR31I8W9nEfvZ4_hORSpoD-3g5To-3DzHFDZRHvCoaES_paSA4fVPRp7bJaiWvZFakz4cJjuk6kaKycbVioy2LwVQtFoir337nWtDk0; notification-sync-seen=1; _ga=GA1.2.623929280.1454984672; __zlcmid=Z6fJa5d2n8Byzo; optimizelySegments=%7B%222774710745%22%3A%22direct%22%2C%222781820595%22%3A%22false%22%2C%222794270093%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; optimizelyPendingLogEvents=%5B%5D"
     )

# 

response = POST(url = address, data=payload)

data <- content(response, as='text')
rides <- as.data.frame(fromJSON(data)$Rides)


