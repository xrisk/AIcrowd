import React from 'react';
import cx from 'classnames';

import LandingNavBar from 'src/components/organisms/LandingNavBar/index';
import MastHeadLanding from 'src/components/organisms/MastHeadLanding/index';
import PartnerBarLanding from 'src/components/organisms/PartnerBarLanding/index';
import LandingCommunityMap from 'src/components/organisms/LandingCommunityMap';
import useBoolean from 'src/hooks/useBoolean';
import LandingMenu from 'src/components/organisms/LandingMenu/index';
import { LandingStatItemProps } from 'src/components/molecules/LandingStatItem';
import LandingHeaderContent from 'src/components/organisms/LandingHeaderContent';
import LandingChallengeCardList from 'src/components/organisms/LandingChallengeCardList';
import { LandingChallengeCardProps } from 'src/components/organisms/LandingChallengeCard';
import LandingNotebookCard, { LandingNotebookCardProps } from 'src/components/molecules/LandingNotebookCard';
import LandingSubmissionCard, { LandingSubmissionCardProps } from 'src/components/molecules/LandingSubmissionCard';
import LandingCarousel from 'src/components/organisms/LandingCarousel';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';

import styles from './landing.module.scss';

const {
  challengesWrapper,
  sectionGap,
  sectionGapReview,
  sectionGapCommunity,
  researchImageWrapper,
  glowDecor1,
  glowDecor2,
  notebookCardWrapper,
  submissionCardWrapper,
  submissionCard,
  mastheadCard,
  organizerLogos2,
  organizerLogos1,
  aicrowdLargeLogo,
  organizerText,
  sectionGapOrganizerLogos,
  carouselWrapper,
} = styles;

type LandingProps = {
  loading: boolean;
  logos: [string];
  challengeListData: [LandingChallengeCardProps];
  statListData: [LandingStatItemProps];
  communityMap: string;
  communityMapAvatar: string;
  moreMenuItem: Array<{ name: string; link: string }>;
  profileMenuItem: Array<{ name: string; link: string }>;
  challengesMenuItem: { name: string; link: string };
  researchMenuItem: { name: string; link: string };
  communityMenuItem: Array<{ name: string; link: string }>;
  landingChallengeCard1: LandingChallengeCardProps;
  landingChallengeCard2: LandingChallengeCardProps;
  landingChallengeCard3: LandingChallengeCardProps;
  notebookCardData: [LandingNotebookCardProps];
  submissionCardData: [LandingSubmissionCardProps];
  quotes: any;
  badgeColor: string;
  challengeEndDate: string;
  cardBadge: boolean;
  communityMembersList: [{ lat: string; lon: string; image: string; name: string }];
  tier: number;
  image: string;
  isLoggedIn: boolean;
  notificationData: any;
};

const Landing = ({
  loading,
  logos,
  challengeListData,
  statListData,
  moreMenuItem,
  challengesMenuItem,
  communityMenuItem,
  profileMenuItem,
  researchMenuItem,
  landingChallengeCard1,
  landingChallengeCard2,
  landingChallengeCard3,
  notebookCardData,
  submissionCardData,
  quotes,
  communityMembersList,
  tier: loggedInUserTier,
  image: loggedInUserImage,
  isLoggedIn,
  notificationData,
}: LandingProps) => {
  const isS = useMediaQuery(sizes.small);
  const isXL = useMediaQuery(sizes.xLarge);
  const isM = useMediaQuery(sizes.medium);
  const isL = useMediaQuery(sizes.large);
  const { value: isMenuOpen, toggle, setValue: setMenu } = useBoolean();

  const challengeDescription = `AIcrowd hosts challenges that tackle diverse problems in Artificial Intelligence with real-world impact.  AIcrowd Community spearheads the state of the art, be it advanced RL innovation or applications of ML in scientific research. There is an interesting problem for everyone.`;

  const notebookDescription = `Browse winning solutions created with`;
  const notebookDescription2 = `by the community. Learn, discuss and grow your AI skills.`;

  const discussionsDescription = `Join our vibrant community of problem solvers like you. Partner with AIcrew members to solve unique challenges or find co-authors for your next research project.  
`;

  const researchDescriptionPara1 = `At AIcrowd Research, we explore our scientific curiosities through challenges while engaging a diverse group of researchers.`;

  const researchDescriptionPara2 = `Led by the principles of Open Science and Reproducible Research, we document these creative solutions for real-world problems. AIcrowd’s community-led research lab publishes papers that consistently push the state-of-the-art in AI.`;

  const organizerLogoList1 = [
    'stanford-logo.png',
    'openai-logo.png',
    'novartis-logo.png',
    'sncf-logo.png',
    'facebook-logo.png',
    'whofull-logo.png',
    'spotify-logo.png',
    'unity-logo.png',
    'amazon-logo.png',
    'microsoft-logo.png',
    'iit-logo.png',
    'eth-logo.png',
  ];

  const organizerLogoList2 = [
    'uber-logo.png',
    'db-logo.png',
    'sony-logo.png',
    'mit-logo.png',
    'sbb-logo.png',
    'who-logo.png',
  ];

  const allOrganizerLogos = [...organizerLogoList1, ...organizerLogoList2];

  return (
    <>
      <LandingNavBar
        handleMenu={toggle}
        isMenuOpen={isMenuOpen}
        setMenu={setMenu}
        moreMenuItem={moreMenuItem}
        challengesMenuItem={challengesMenuItem}
        communityMenuItem={communityMenuItem}
        profileMenuItem={profileMenuItem}
        researchMenuItem={researchMenuItem}
        tier={loggedInUserTier}
        image={loggedInUserImage}
        loading={loading}
        isLoggedIn={isLoggedIn}
        notificationData={notificationData}
      />
      {isMenuOpen && <LandingMenu profileMenuItem={profileMenuItem} isLoggedIn={isLoggedIn} />}
      <div className="container-center">
        <div className={mastheadCard}>
          <MastHeadLanding
            statListData={statListData}
            landingChallengeCard1={landingChallengeCard1}
            landingChallengeCard2={landingChallengeCard2}
            landingChallengeCard3={landingChallengeCard3}
            loading={loading}
          />
        </div>
        <main>
          <PartnerBarLanding logos={logos} />
          <div className={cx(styles['landing-main'], 'border-top')}>
            {/* Our Challenges */}
            <section className={cx(challengesWrapper, sectionGap)}>
              <div>
                <LandingHeaderContent
                  title="Our Challenges"
                  description={challengeDescription}
                  buttonText="Explore Challenges"
                  url="/challenges"
                  descriptionWidth={isL ? '100%' : isXL ? '389px' : '560px'}
                />
                {/* aicrowd large logo */}
                {!isS && (
                  <img
                    src="https://images.aicrowd.com/images/landing_page/landingAicrowdSketch.png"
                    alt="aicrowd logo"
                    className={aicrowdLargeLogo}
                    width="100%"></img>
                )}
              </div>
              <LandingChallengeCardList challengeListData={challengeListData} loading={loading} />
            </section>
            {/* Your solutions */}
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingBottom: isM ? '64px' : '200px' }}>
              <div>
                <LandingHeaderContent
                  title="Your Solutions"
                  description={[
                    notebookDescription,
                    ' ',
                    <span role="img" aria-label="sheep" key={'heart'}>
                      {'\u2764\uFE0F'}
                    </span>,
                    ' ',
                    [notebookDescription2],
                  ]}
                  buttonText="Explore Notebooks"
                  url="/notebooks"
                  descriptionWidth={isL ? '100%' : isXL ? '481px' : '560px'}
                />
              </div>
              <div>
                {/* Notebook cards */}
                <div className={notebookCardWrapper}>
                  {notebookCardData.map((item, i) => {
                    const { title, description, lastUpdated, image, author, url } = item;
                    return (
                      <div key={i} data-notebook={i + 1}>
                        <LandingNotebookCard
                          title={title}
                          description={description}
                          lastUpdated={lastUpdated}
                          image={image}
                          author={author}
                          url={url}
                        />
                      </div>
                    );
                  })}
                </div>
              </div>
            </section>

            {/* The Community */}
            <section className={cx(challengesWrapper, sectionGapCommunity)}>
              <div>
                <LandingHeaderContent
                  title="The Community"
                  description={[discussionsDescription, <br />, <br />, 'On AIcrowd forums, find your AI tribe.']}
                  buttonText="Explore Discussions"
                  url="/discussions"
                  descriptionWidth={isL ? '100%' : isXL ? '541px' : '621px'}
                />
              </div>
              <div>
                <div className={submissionCardWrapper}>
                  <div>
                    {submissionCardData.map((item, i) => {
                      const { title, description, comment_count, tier, image, loading, borderColor, url } = item;
                      return (
                        <div key={i} data-submission={i + 1} className={submissionCard}>
                          <LandingSubmissionCard
                            title={title}
                            description={description}
                            comment_count={comment_count}
                            tier={tier}
                            image={image}
                            loading={loading}
                            borderColor={borderColor}
                            url={url}
                          />
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </section>

            {/* AIcrowd Banner  */}
            <section className={cx(challengesWrapper)}>
              <img
                src={`https://images.aicrowd.com/images/landing_page/${isS ? 'aicrowdBannerMobile' : 'aicrowdBanner'}.png`}
                alt="aicrowd banner"
                width="100%"></img>
            </section>

            {/* AIcrowd Research  */}
            <section className={cx(challengesWrapper, sectionGap)}>
              <div>
                <LandingHeaderContent
                  title="Research"
                  description={[
                    researchDescriptionPara1,
                    <br key={'br1'} />,
                    <br key={'br2'} />,
                    researchDescriptionPara2,
                  ]}
                  buttonText="Research Papers"
                  url="/research"
                  logo
                  descriptionWidth={isL ? '100%' : isXL ? '541px' : '560px'}
                />
              </div>
              <div className={researchImageWrapper}>
                <img src="https://images.aicrowd.com/images/landing_page/learning_run.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/mars_demo.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/flatland.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/bill-gates-tweet.png"></img>
              </div>
            </section>

            {/* Quotations */}
            <section className={cx(challengesWrapper, sectionGapReview)}>
              <div className={carouselWrapper}>
                <LandingCarousel {...quotes} />
              </div>
              <span className={glowDecor1}></span>
              <span className={glowDecor2}></span>
            </section>

            {/* Join Our Global community  */}
            <section className={cx(challengesWrapper)}>
              <div>
                <LandingHeaderContent
                  title={isLoggedIn ? 'Welcome to AIcrowd Community' : 'Join our Global Community'}
                  description=""
                  buttonText="Join Now"
                  descriptionWidth={isS ? '288px' : '496px'}
                  isLoggedIn={isLoggedIn}
                />
              </div>
              <div style={{ paddingTop: isS && '64px', width: '100%' }}>
                <LandingCommunityMap communityMembersList={communityMembersList} />
              </div>
            </section>

            {/* Organizers logos section */}
            <div className={organizerText}>Trusted and Used by</div>
            <section className={cx(sectionGapOrganizerLogos)}>
              <div>
                {/* Organizers logo1  */}
                {!isL && (
                  <div className={organizerLogos1}>
                    {organizerLogoList1.map(fileName => {
                      return <img src={`https://images.aicrowd.com/images/landing_page/${fileName}`} key={fileName}></img>;
                    })}
                  </div>
                )}
                {/* Show only for tablet & mobile screen */}
                {isL && (
                  <div className={organizerLogos1}>
                    {allOrganizerLogos.map(fileName => {
                      return <img src={`https://images.aicrowd.com/images/landing_page/${fileName}`} key={fileName}></img>;
                    })}
                  </div>
                )}
              </div>
            </section>
            {/* Host a Challenge */}
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingTop: '40px' }}>
              <LandingHeaderContent
                title="Host a Challenge"
                description={[
                  'Have an interesting out-of-box problem you want to solve?',
                  <br key={'br1'} />,
                  'Get in touch to host a customized challenge and unlock an array of exclusive features.',
                ]}
                buttonText="Get In Touch"
                url="/"
                buttonType="primary"
                descriptionWidth={isL ? '100%' : isXL ? '541px' : '752px'}
              />
              {/* Organizers logo2  */}
              <div className={organizerLogos2}>
                {organizerLogoList2.map(fileName => {
                  return <img src={`https://images.aicrowd.com/images/landing_page/${fileName}`} key={fileName}></img>;
                })}
              </div>
            </section>
          </div>
        </main>
      </div>
    </>
  );
};

export default Landing;
