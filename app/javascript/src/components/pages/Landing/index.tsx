import React from 'react';
import cx from 'classnames';
import Image from 'next/image';

import LandingNavBar from 'src/components/organisms/LandingNavBar/index';
import MastHeadLanding from 'src/components/organisms/MastHeadLanding/index';
import PartnerBarLanding from 'src/components/organisms/PartnerBarLanding/index';
import LandingCommunityMap from 'src/components/organisms/LandingCommunityMap';
import useBoolean from 'src/hooks/useBoolean';
import LandingMenu from 'src/components/organisms/LandingMenu/index';

import { LandingStatItemProps } from 'src/components/molecules/LandingStatItem';
import LandingHeaderContent from 'src/components/organisms/LandingHeaderContent';
import LandingFeatureItem from 'src/components/molecules/LandingFeatureItem';
import LandingChallengeCardList from 'src/components/organisms/LandingChallengeCardList';
import { LandingChallengeCardProps } from 'src/components/organisms/LandingChallengeCard';

import styles from './landing.module.scss';
import LandingNotebookCard, { LandingNotebookCardProps } from 'src/components/molecules/LandingNotebookCard';
import LandingSubmissionCard, { LandingSubmissionCardProps } from 'src/components/molecules/LandingSubmissionCard';
import LandingContributorCard, { LandingContributorCardProps } from 'src/components/molecules/LandingContributorCard';
import Map from './Map';
import LandingCarousel from 'src/components/organisms/LandingCarousel';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';
const {
  challengesWrapper,
  sectionGap,
  sectionGapOrganizers,
  sectionGapReview,
  sectionGapCommunity,
  researchImageWrapper,
  glowDecor1,
  glowDecor2,
  notebookCardWrapper,
  submissionCardWrapper,
  submissionCard,
  topCommunity,
  topCommunityCardWrapper,
  contributorCard,
  mastheadCard,
  organizerLogos2,
  organizerLogos1,
  aicrowdLargeLogo,
  partnerLogo,
  organizerText,
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
  communityMenuItem: Array<{ name: string; link: string }>;
  landingChallengeCard1: LandingChallengeCardProps;
  landingChallengeCard2: LandingChallengeCardProps;
  landingChallengeCard3: LandingChallengeCardProps;
  notebookCardData: [LandingNotebookCardProps];
  submissionCardData: [LandingSubmissionCardProps];
  contributorCardData: [LandingContributorCardProps];
  quotes: any;
  badgeColor: string;
  challengeEndDate: string;
  cardBadge: boolean;
  communityMembersList: [{ lat: string; lon: string; image: string; name: string }];
  tier: number;
  image: string;
  isLoggedIn: boolean;
};

const Landing = ({
  loading,
  logos,
  challengeListData,
  statListData,
  communityMap,
  communityMapAvatar,
  moreMenuItem,
  challengesMenuItem,
  communityMenuItem,
  profileMenuItem,
  landingChallengeCard1,
  landingChallengeCard2,
  landingChallengeCard3,
  notebookCardData,
  submissionCardData,
  contributorCardData,
  quotes,
  badgeColor,
  challengeEndDate,
  cardBadge,
  communityMembersList,
  tier: loggedInUserTier,
  image: loggedInUserImage,
  isLoggedIn,
}: LandingProps) => {
  const isS = useMediaQuery(sizes.small);
  const isXL = useMediaQuery(sizes.xLarge);
  const isM = useMediaQuery(sizes.medium);
  const { value: isMenuOpen, toggle, setValue: setMenu } = useBoolean();

  const challengeDescription = `AIcrowd hosts challenges that tackle diverse problems in Artificial Intelligence with real-world impact.  AIcrowd Community spearheads the state of the art, be it advanced RL innovation or applications of ML in scientific research. There is an interesting problem for everyone.`;

  const notebookDescription = `Browse winning solutions created with`;
  const notebookDescription2 = `by the community. Learn, discuss and grow your AI skills.`;

  const discussionsDescription = `Join our vibrant community of problem solvers like you. Partner with AIcrew members to solve unique challenges or find co-authors for your next research project.  
`;

  const researchDescriptionPara1 = `At AIcrowd Research, we explore our scientific curiosities through challenges while engaging a diverse group of researchers.`;

  const researchDescriptionPara2 = `Led by the principles of Open Science and Reproducible Research, we document these creative solutions for real-world problems. AIcrowd’s community-led research lab publishes papers that consistently push the state-of-the-art in AI.`;

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
        tier={loggedInUserTier}
        image={loggedInUserImage}
        loading={loading}
        isLoggedIn={isLoggedIn}
      />
      {isMenuOpen && <LandingMenu isLoggedIn={isLoggedIn} profileMenuItem={profileMenuItem} />}
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
                  url="/challenges"
                  title="Our Challenges"
                  description={challengeDescription}
                  buttonText="Explore Challenges"
                  descriptionWidth={isS ? '288px' : isXL ? '389px' : '560px'}
                />
                {/* aicrowd large logo */}
                {!isS && (
                  <img
                    src="/assets/misc/landingAicrowdSketch.png"
                    alt="aicrowd logo"
                    className={aicrowdLargeLogo}
                    width="100%"></img>
                )}
                {/* {!isS && (
                  <div style={{ paddingTop: '114px' }}>
                    <div style={{ paddingBottom: '32px' }}>
                      <LandingFeatureItem
                        title="Out-of-the-Box Challenges"
                        description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      />
                    </div>
                    <LandingFeatureItem
                      title="Celebrate Non-Standard Ideas "
                      description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    />
                  </div>
                )} */}
              </div>
              <LandingChallengeCardList challengeListData={challengeListData} loading={loading} />
            </section>
            {/* Your solutions */}
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingBottom: isM ? '64px' : '200px' }}>
              <div>
                <LandingHeaderContent
                  title="Your Solutions"
                  url="/showcase"
                  description={[
                    notebookDescription,
                    ' ',
                    <span role="img" aria-label="sheep" key={'heart'}>
                      ❤️
                    </span>,
                    ' ',
                    [notebookDescription2],
                  ]}
                  buttonText="Explore Notebooks"
                  descriptionWidth={isS ? '288px' : isXL ? '481px' : '560px'}
                />
                {/* {!isS && (
                  <div style={{ paddingTop: '114px' }}>
                    <div style={{ paddingBottom: '32px' }}>
                      <LandingFeatureItem
                        title="Out-of-the-Box Challenges"
                        description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      />
                    </div>
                  </div>
                )} */}
              </div>
              <div>
                {/* Notebook cards */}
                <div className={notebookCardWrapper}>
                  {notebookCardData.map((item, i) => {
                    const { slug, title, description, lastUpdated, image, author } = item;
                    return (
                      <div key={i} data-notebook={i + 1}>
                        <LandingNotebookCard
                          slug={slug}
                          title={title}
                          description={description}
                          lastUpdated={lastUpdated}
                          image={image}
                          author={author}
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
                  url="//discourse.aicrowd.com"
                  description={[discussionsDescription, <br />, <br />, 'On AIcrowd forums, find your AI tribe.']}
                  buttonText="Explore Discussions"
                  descriptionWidth={isS ? '288px' : isXL ? '541px' : '621px'}
                />
                {/* {!isS && (
                  <div style={{ paddingTop: isXL ? '84px' : '114px' }}>
                    <div style={{ paddingBottom: '32px' }}>
                      <LandingFeatureItem
                        title="Research Driven"
                        description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      />
                    </div>
                  </div>
                )} */}
              </div>
              <div>
                <div className={submissionCardWrapper}>
                  <div>
                    {submissionCardData.map((item, i) => {
                      const { url, title, description, comment_count, tier, image, loading, borderColor } = item;
                      return (
                        <div key={i} data-submission={i + 1} className={submissionCard}>
                        <a href={url}>
                          <LandingSubmissionCard
                            url={url}
                            title={title}
                            description={description}
                            comment_count={comment_count}
                            tier={tier}
                            image={image}
                            loading={loading}
                            borderColor={borderColor}
                          />
                          </a>
                        </div>
                      );
                    })}
                  </div>
                </div>
                {/* {!isXL && (
                  <div className={topCommunity}>
                    <h6>Top Community Contributors</h6>
                    <div className={topCommunityCardWrapper}>
                      {contributorCardData.map((item, i) => {
                        const { username, count, tier, image, loading, onCard, borderColor } = item;
                        return (
                          <div key={i} className={contributorCard}>
                            <LandingContributorCard
                              username={username}
                              count={count}
                              tier={tier}
                              image={image}
                              loading={loading}
                              onCard={onCard}
                              borderColor={borderColor}
                            />
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )} */}
              </div>
            </section>
            {/* {isXL && (
              <div className={topCommunity}>
                <h6>Top Community Contributors</h6>
                <div className={topCommunityCardWrapper}>
                  {contributorCardData.map((item, i) => {
                    const { username, count, tier, image, loading, onCard, borderColor } = item;
                    return (
                      <div key={i} className={contributorCard}>
                        <LandingContributorCard
                          username={username}
                          count={count}
                          tier={tier}
                          image={image}
                          loading={loading}
                          onCard={onCard}
                          borderColor={borderColor}
                        />
                      </div>
                    );
                  })}
                </div>
              </div>
            )} */}

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
                  url="/research"
                  description={[
                    researchDescriptionPara1,
                    <br key={'br1'} />,
                    <br key={'br2'} />,
                    researchDescriptionPara2,
                  ]}
                  buttonText="Research Papers"
                  logo
                  descriptionWidth={isS ? '288px' : isXL ? '541px' : '560px'}
                />
                {/* {!isS && (
                  <div style={{ paddingTop: '114px' }}>
                    <div style={{ paddingBottom: '32px' }}>
                      <LandingFeatureItem
                        title="Celebrate Non-Standard Ideas "
                        description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      />
                    </div>
                  </div>
                )} */}
              </div>
              <div className={researchImageWrapper}>
                <img src="https://images.aicrowd.com/images/landing_page/learning_run.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/mars_demo.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/flatland.gif"></img>
                <img src="https://images.aicrowd.com/images/landing_page/bill-gates-tweet.png"></img>
              </div>
            </section>

            {/* Quotations */}
            <section
              className={cx(challengesWrapper, sectionGapReview)}
              style={{ display: 'flex', justifyContent: 'center', marginTop: '221px' }}>
              <LandingCarousel {...quotes} />
              <span className={glowDecor1}></span>
              <span className={glowDecor2}></span>
            </section>

            {/* Join Our Global community  */}
            <section className={cx(challengesWrapper)}>
              <div>
                {isLoggedIn && (<LandingHeaderContent
                  title="Welcome to AIcrowd Community"
                  description=""
                  buttonText="Join Now"
                  descriptionWidth={isS ? '288px' : '496px'}
                />)}
                {!isLoggedIn && (<LandingHeaderContent
                  title="Join our Global Community"
                  description=""
                  buttonText="Join Now"
                  descriptionWidth={isS ? '288px' : '496px'}
                />)}
              </div>
              {/* <LandingCommunityMap communityMap={communityMap} communityMapAvatar={communityMapAvatar} /> */}
              <div style={{ paddingTop: isS && '64px', width: '100%' }}>
                <Map communityMembersList={communityMembersList} />
              </div>
            </section>

            {/* Organizers logos section */}
            <section
              style={{ display: 'flex', justifyContent: 'flex-end', paddingTop: '54px' }}
              className={cx(sectionGap)}>
              <div>
                <div className={organizerText}>
                  From Fortune 500 companies to unicorn startups, we have implemented diverse and unique ideas
                </div>
                <div className={organizerLogos1}>
                  <img src="https://images.aicrowd.com/images/landing_page/stanford-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/openai-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/novartis-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/sncf-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/facebook-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/whofull-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/spotify-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/unity-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/amazon-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/microsoft-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/iit-logo.png"></img>
                  <img src="https://images.aicrowd.com/images/landing_page/eth-logo.png"></img>
                </div>
              </div>
            </section>
            {/* Host a Challenge */}
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingTop: '56px' }}>
              <LandingHeaderContent
                title="Host a Challenge"
                url="/landing_page/host"
                description={[
                  'Have an interesting out-of-box problem you want to solve?',
                  <br key={'br1'} />,
                  'Get in touch to host a customized challenge and unlock an array of exclusive features.',
                ]}
                buttonText="Get In Touch"
                buttonType="primary"
                descriptionWidth={isS ? '288px' : '752px'}
              />
              <div className={organizerLogos2}>
                <img src="https://images.aicrowd.com/images/landing_page/uber-logo.png"></img>
                <img src="https://images.aicrowd.com/images/landing_page/db-logo.png"></img>
                <img src="https://images.aicrowd.com/images/landing_page/sony-logo.png"></img>
                <img src="https://images.aicrowd.com/images/landing_page/mit-logo.png"></img>
                <img src="https://images.aicrowd.com/images/landing_page/sbb-logo.png"></img>
                <img src="https://images.aicrowd.com/images/landing_page/who-logo.png"></img>
              </div>
            </section>
          </div>
        </main>
      </div>
    </>
  );
};

export default Landing;
