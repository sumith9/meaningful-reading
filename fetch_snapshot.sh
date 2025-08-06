#!/bin/bash

# Check if snapshot ID is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <snapshot_id>"
    echo "Example: $0 4"
    exit 1
fi

snapshot_id="$1"
url="https://app-accessibility.browserstack.com/api/v1/admin_tool/get-snapshot?id=${snapshot_id}"
snapshots_dir="/Users/poonersumith/Desktop/meaningful-reading-order/snapshots"
filename="snapshot_${snapshot_id}.json"
filepath="${snapshots_dir}/${filename}"

# Create snapshots directory if it doesn't exist
mkdir -p "$snapshots_dir"

echo "Fetching snapshot ${snapshot_id}..."
echo "URL: $url"

# Cookie string - all your authentication data
cookie="appa11yaffinity=1754379114.191.66.120441|bc8c47f98d78975c7b4e4895558a372e; tracking_id=bb96f9cb-cb42-4c4d-9b35-94bdd3c8e462; _authcookie=783071cc57cab6709de1245d076c7fd9; is_trustarc_enabled=true; _gcl_au=1.1.2011242502.1750864986; _vwo_uuid_v2=D92212D62BFBC6FEA0FBDE6D1B95CB70E|1d6bbb54bc562de57ab648466ae60fc4; _vwo_ds=3%3At_0%2Ca_0%3A0%241750864985%3A80.41461481%3A%3A%3A5_0%2C3_0%3A1; bs_deviceId=774b1366-7ae5-c532-81da-1ecbddcdb07c; ConsentGeoDetail={\"showNewBanner\":false,\"continent\":\"AS\",\"region\":\"Telangana\"}; _fuid=NTA1N2ZkYjYtMDYyYS00NDBjLThkMTItYzI1NzY3OWYxMmYz; _session=6e28ce73a7f5e95ff51e2df57803dd60; bs_logging_id=9184249; bs_group_id=2; bs_chat_channels=paid_user; _BEAMER_USER_ID_xTSGUhhN11000=a6d182f0-5b24-4f6b-8a97-63bb5ffbd7a8; _BEAMER_FIRST_VISIT_xTSGUhhN11000=2025-06-25T15:23:19.891Z; _fbp=fb.1.1750865008239.521644114851553752; notice_gdpr_prefs=0|1|2|3:; skipped_extension_install_sumithpooner_6pzaVG=true; _BEAMER_DATE_xTSGUhhN11000=2025-06-27T03:37:10.767Z; last_visited_product_page=live; ab_users=%7B%22108%22%3A236%2C%22113%22%3A248%7D; _gat_gtag_UA_418548_19=1; ga_pa_status=npa; moved=1; AMP_MKTG_985eaa9c45=JTdCJTdE; _vis_opt_s=1%7C; _vis_opt_test_cookie=1; _vwo_uuid=DBE5AA78C2A43DB09FA639428BFFB57CB; bs_user_details={\"user_details\":{\"user_id\":9184249,\"group_id\":2},\"plan_details\":{\"live_testing\":{\"type\":\"Extended Trial\"},\"automate\":{\"type\":\"Extended Trial\"},\"screenshot\":{\"type\":\"Extended Trial\"},\"app_live_testing\":{\"type\":\"Extended Trial\"},\"app_automate\":{\"type\":\"Extended Trial\"},\"percy\":{\"type\":\"Extended Trial\"},\"high_scale_testing\":{\"type\":\"Trial\"},\"testing_toolkit\":{\"type\":\"Extended Trial\"},\"central_scanner\":{\"type\":\"Trial\"},\"requestly\":{\"type\":\"Extended Trial\"},\"app_automate_addon_tam\":{\"type\":\"Trial\"},\"automate_addon_tam\":{\"type\":\"Trial\"},\"bug_capture\":{\"type\":\"Extended Trial\"},\"app_accessibility_testing\":{\"type\":\"Extended Trial\"},\"automate_turboscale\":{\"type\":\"Extended Trial\"},\"low_code_automation\":{\"type\":\"Extended Trial\"},\"code_quality_self_managed\":{\"type\":\"Extended Trial\"},\"code_quality_cloud\":{\"type\":\"Extended Trial\"},\"test_management\":{\"type\":\"Extended Trial\"},\"accessibility_testing\":{\"type\":\"Extended Trial\"},\"test_observability\":{\"type\":\"Extended Trial\"},\"app_percy\":{\"type\":\"Extended Trial\"}}}; last_active_integration=jira; integrations_UAT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTM3MDQwMDUsImRhdGEiOnsidXNlciI6eyJncm91cElkIjoyLCJleHRlcm5hbFVzZXJJZCI6IjkxODQyNDkiLCJleHRlcm5hbEdyb3VwSWQiOjIsImNvbmZpZ3VyYXRpb25JZCI6MTJ9fSwiaWF0IjoxNzUzNzAzMTA1fQ.gfFLoR0pc1bZqDBkrJiZ_T6PVXGnKkCYEXP1auGshNw; _cfuvid=DbE2MdS.lA4uaEqRqDxFsi5TXU8hgkhjGYTkFtCNDn4-1753862442245-0.0.1.1-604800000; notice_behavior=implied|as; _ga_19PMLW8E88=GS2.2.s1754031966\$o6\$g1\$t1754032253\$j60\$l0\$h0; _gid=GA1.2.484773148.1754295405; downtime_notified={\"notifDowntime\":false,\"activeDowntime\":false}; GAstartTime=1754378705081; previous_session_os=realdroid; GAlastSentTime=1754379178995; cf_clearance=tioZ1yWwv8W6QCwbgzTy11njS6mFsWngsoGvIZ079RA-1754379180-1.2.1.1-9WdZLg6ZqfirdgnE1vPSD7KB22VD72zbRPPfG48ho.bGj1R_EOsQrM9SPrl7ICVO0Z1agfT0xE2Dyy4QTxx.cQszfS8J7cFtprquFG5UB.Z19eRIxlfgfIgeut.Rvyi_N11CQb0JrU5QsuZeUIwBSDlp_fvvrCv8z5nQaI_JsKwiWJJ3MXoAcPUCCZ_2c5gOA6RgiVGL8Pw1B6D4LnmMXMSsF62Woh_ylUee_MHhE7w; _rdt_uuid=1750865013615.b0ae4552-1ce3-4b37-a697-a3007e6e8217; _uetsid=acf1e02071b411f0aa151fb7fd926ef8; _uetvid=4bf2cee0b5eb11ef84f45b9cd7bfd2e0; amplitude_id_985eaa9c45d824a94344e64a2a3ca724browserstack.com=eyJkZXZpY2VJZCI6Ijc3NGIxMzY2LTdhZTUtYzUzMi04MWRhLTFlY2JkZGNkYjA3YyIsInVzZXJJZCI6IjkxODQyNDkiLCJvcHRPdXQiOmZhbHNlLCJzZXNzaW9uSWQiOjE3NTQzNzg3MDYwNjEsImxhc3RFdmVudFRpbWUiOjE3NTQzNzkyNDQzNDUsImV2ZW50SWQiOjUyMCwiaWRlbnRpZnlJZCI6Mjg2LCJzZXF1ZW5jZU51bWJlciI6ODA2fQ==; __cf_bm=QNVz532sHwXpCW2WfDvUdNGsEVWeM9FVAsy2DcPIaRI-1754379765-1.0.1.1-gSl2FNa.py78KY1djHw5NRfsibAyvb0Yhrd3_aQrSk6QEkTngbiW_DH5Dgi.iDdjHP.1qvFufcZRyuIO6uE68pn4X2cKOLnCt6eDHmvG7Jw; page_unloaded=1754380367427; last_dashboard_visited_webex=app-accessibility.browserstack.com; bs_token=eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3NTQzODM5NjcsImlzcyI6Ind3dy5icm93c2Vyc3RhY2suY29tIiwic3ViIjo5MTg0MjQ5fQ.aszyLT0TvTNOg0x1uNN0loJCGnwoLdAWbXfNmr1NXcA; AMP_985eaa9c45=JTdCJTIyZGV2aWNlSWQlMjIlM0ElMjI1YmQ5NzcwNC02NzJmLTE2YTQtYzMxNC0yYzJlYjM2YWIyOWMlMjIlMkMlMjJ1c2VySWQlMjIlM0E5MTg0MjQ5JTJDJTIyc2Vzc2lvbklkJTIyJTNBMTc1NDM3NjcwMzIxNiUyQyUyMm9wdE91dCUyMiUzQWZhbHNlJTJDJTIybGFzdEV2ZW50VGltZSUyMiUzQTE3NTQzODAzNjc5MDglMkMlMjJsYXN0RXZlbnRJZCUyMiUzQTEyODkxJTJDJTIycGFnZUNvdW50ZXIlMjIlM0ExJTdE; _BEAMER_FILTER_BY_URL_xTSGUhhN11000=true; _ga=GA1.2.763821530.1739437677; _BEAMER_FILTER_BY_URL_xTSGUhhN11000=true; _BEAMER_LAST_UPDATE_xTSGUhhN11000=1754380368850; _ga_BBS5LEDVRG=GS2.1.s1754366814\$o154\$g1\$t1754380369\$j58\$l0\$h2097088538; integrations_UAT_setup-status=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTQzODEyNjksImRhdGEiOnsidXNlciI6eyJncm91cElkIjoyLCJleHRlcm5hbFVzZXJJZCI6IjkxODQyNDkiLCJleHRlcm5hbEdyb3VwSWQiOjIsImNvbmZpZ3VyYXRpb25JZCI6MTJ9fSwiaWF0IjoxNzU0MzgwMzY5fQ.9enhmlDlTN_e5yh8lXltMq131QQ15h4nLo9xQPiKKnI"

# Fetch data with browser headers
temp_file=$(mktemp)

echo "Fetching snapshot data..."
http_code=$(curl -s -w "%{http_code}" \
    -H "Cookie: $cookie" \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    -H "Accept: application/json, text/plain, */*" \
    -H "Accept-Language: en-US,en;q=0.9" \
    -H "Referer: https://app-accessibility.browserstack.com/" \
    -H "X-Requested-With: XMLHttpRequest" \
    "$url" -o "$temp_file")

echo "HTTP Status: $http_code"

# Check if we got actual data (regardless of HTTP status)
if [ -s "$temp_file" ]; then
    # Check if response contains success:true or actual data
    if grep -q '"success":true' "$temp_file" || grep -q '"data"' "$temp_file"; then
        cp "$temp_file" "$filepath"
        echo "✅ Successfully saved snapshot to: $filepath"
        echo "📊 File size: $(wc -c < "$filepath") bytes"
        
        # Pretty print first few lines to verify content
        echo "📋 Preview of saved data:"
        head -c 200 "$filepath" | jq '.' 2>/dev/null || head -c 200 "$filepath"
        echo "..."
    else
        echo "❌ Response doesn't contain expected data structure"
        cat "$temp_file"
    fi
else
    echo "❌ No data received"
fi

rm "$temp_file"