import os
import sys
import glob
import shutil
import fileinput

REACT_COMPONENTS_PATH = "../aicrowd-components-library/src/components/"

enabled_components = [
  "molecules/AvatarGroup",
  "molecules/LandingContributorCard",
  "molecules/AchievementProgress",
  "molecules/LandingSubmissionCard",
  "molecules/AchievementDetail",
  "molecules/LandingDropdownMenu",
  "molecules/LandingStatItem",
  "molecules/LandingNotebookCard",
  "molecules/AchievementPopup",
  "molecules/LandingFeatureItem",
  "molecules/notificationItem",
  "atoms/AicrowdLogo",
  "atoms/AvatarWithTier",
  "atoms/CardBadge",
  "atoms/Button",
  "atoms/Link",
  "atoms/LogoMark",
  "atoms/CircleValue",
  "atoms/Tooltip",
  "old/LandingChallengeCard1",
  "pages/Landing",
  "organisms/PartnerBarLanding",
  "organisms/LandingCommunityMap",
  "organisms/LandingMenu",
  "organisms/LandingChallengeCard",
  "organisms/LandingChallengeCardList",
  "organisms/AchievementListItem",
  "organisms/LandingStatList",
  "organisms/MastHeadLanding",
  "organisms/LandingNavBar",
  "organisms/LandingCarousel",
  "organisms/LandingHeaderContent",
  "utility/HorizontalScroll"
]

def sync_repo_with_upstream(component):
    # Copy the new codebase
    print("Copying %s..." % component)
    upstream = os.path.join(REACT_COMPONENTS_PATH, component)
    localstream = os.path.join("app/javascript/src/components", component)
    sync_folders(localstream, upstream)
    
    
def sync_folders(localstream, upstream):
    if os.path.exists(localstream):
        shutil.rmtree(localstream)
    shutil.copytree(upstream, localstream)
    
    # Removing .stories.js
    for stories_js in glob.glob(os.path.join(localstream, '*.stories.js')):
        os.remove(stories_js)
    for stories_js in glob.glob(os.path.join(localstream, '*/*.stories.js')):
        os.remove(stories_js)
    
    # Import fixes
    print("...scss fixes in %s" % localstream)
    
    nops = []
    
    replacements = [
        ["@import \"./src/", "@import \"../../../"],
        ["url(\"/assets/images/", "url(\"/assets/img/"],
        ["/assets/social/", "https://images.aicrowd.com/images/landing_page/"],
        ["/assets/images/logos/", "https://images.aicrowd.com/images/landing_page/"],
        ["/assets/home/", "https://images.aicrowd.com/images/landing_page/"],
        ["<Image", "<img"],
        ["url=\"/notebooks\"", "url=\"/showcase\""],
        ["'/discussions", "'https://discourse.aicrowd.com/"],
        ["'/notebooks", "'/showcase"],
        ["'/register", "'/participants/sign_up"],
        ["/login", "/participants/sign_in"],
        ["/signup", "/participants/sign_up"],
        ["/community", "/showcase"],
        ["/blog", "https://blog.aicrowd.com/"],
        ["/host-a-Challenge", "/landing_page/host"],
        ["/forum", "https://discourse.aicrowd.com/"],
        ["<a>Community</a>", "<a>Showcase</a>"],
        ["<a>Community</a>", "<a>Showcase</a>"],
        [".btn-notifications {", ".btn-notifications { display: none;"],
        ["router.push(", "(window.location.href="],
    ]

    last_line = ""
    for scss_file in glob.glob(os.path.join(localstream, '*.scss')) + glob.glob(os.path.join(localstream, 'index.*')):
        with fileinput.FileInput(scss_file, inplace = True) as f:
            for line in f:
                for r in replacements:
                    line = line.replace(r[0], r[1])
                
                skip = False
                for nop in nops:
                    if nop in line:
                        skip = True

                if "Get In Touch" in last_line or "Host a Challenge" in last_line:
                    line = line.replace('url="/"', 'url="/landing_page/host"')
                    line = line.replace('url="/challenges"', 'url="/landing_page/host"')

                if "type=\"google\"" in line and "handleClick" in line:
                    line = line.replace("'/'", "'/participants/auth/google_oauth2'")

                if "type=\"github\"" in line and "handleClick" in line:
                    line = line.replace("'/'", "'/participants/auth/github'")
                
                last_line = line
                        
                if not skip:
                    print(line, end='')

    replacements = [
        ["@import \"./src/", "@import \"../../../../"],
        ["url(\"/assets/images/", "url(\"/assets/img/"],
        ["/assets/social/", "https://images.aicrowd.com/images/landing_page/"],
        ["/assets/images/logos/", "https://images.aicrowd.com/images/landing_page/"],
        ["/assets/home/", "https://images.aicrowd.com/images/landing_page/"],
        ["<Image", "<img"],
    ]
    
    for scss_file in glob.glob(os.path.join(localstream, '*/*.scss')) + glob.glob(os.path.join(localstream, '*/index.*')):
        with fileinput.FileInput(scss_file, inplace = True) as f:
            for line in f:
                for r in replacements:
                    line = line.replace(r[0], r[1])
                
                skip = False
                for nop in nops:
                    if nop in line:
                        skip = True

                if not skip:
                    print(line, end='')

    # NextJS native removal
    for file in glob.glob(os.path.join(localstream, '*.tsx')):
        with fileinput.FileInput(file, inplace = True) as f:
            for line in f:
                print(line\
                      .replace("import Link from 'next/link';", "import Link from 'src/components/atoms/Link';")\
                      .replace("<Link", "<a")\
                      .replace("</Link>", "</a>")
                      , end='')

    # Temperory hack for the front banner, till fixed in frontend
    if "organisms/PartnerBarLanding" in localstream:
        with open(os.path.join(localstream, 'partnerBarLanding.module.scss'), "a") as f:
            f.write("""
            
            .partners-bar-image {
                height: unset !important;
            }
            
            .partners-bar-image img {
                width: 80px;
            }
            
            """)

for enabled_component in enabled_components:
    sync_repo_with_upstream(enabled_component)

sync_folders("app/javascript/src/constants/scss", os.path.join(REACT_COMPONENTS_PATH, "../", "constants/scss"))
