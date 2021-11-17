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
} = styles;

type LandingProps = {
  loading: boolean;
  logos: [string];
  challengeListData: [LandingChallengeCardProps];
  statListData: [LandingStatItemProps];
  communityMap: string;
  communityMapAvatar: string;
  moreMenuItem: Array<{ name: string; link: string }>;
  challengesMenuItem: Array<{ name: string; link: string }>;
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
  communityMembersList
}: LandingProps) => {
  const isS = useMediaQuery(sizes.small);
  const isXL = useMediaQuery(sizes.xLarge);
  const { value: isMenuOpen, toggle, setValue: setMenu } = useBoolean();

  const challengeDescription = `AIcrowd consistently pushes the state of art in AI with impactful real-world challenges - ranging from advances in Reinforcement learning to applications of ML in scientific research`;

  const notebookDescription = `Browse winning solutions created with ❤️ by the community. Learn, discuss and grow your AI skills.`;

  const discussionsDescription = `Join our vibrant community of problem solvers like you. Partner with AIcrew members to solve unique challenges or find co-authors for your next research project.  
`;

  const researchDescriptionPara1 = `AIcrowd Research explores scientific curiosities through challenges by engaging a diverse group of intellectuals.`;

  const researchDescriptionPara2 = `Led by the principles of Open Research and Reproducible Science, we document these creative solutions for real-world problems. AIcrowd’s community-led research lab publishes papers that consistently push the state-of-the-art in AI.`;

  // const globalDescription = `The AIcrowd community tackles the most diverse and interesting problems in AI,
  // from research advances. The AIcrowd community tackles the.`;

  return (
    <>
      <LandingNavBar
        handleMenu={toggle}
        isMenuOpen={isMenuOpen}
        setMenu={setMenu}
        moreMenuItem={moreMenuItem}
        challengesMenuItem={challengesMenuItem}
        communityMenuItem={communityMenuItem}
      />
      <div className="container-center">
        {isMenuOpen && <LandingMenu />}
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
                  buttonText="Explore challenges"
                  descriptionWidth={isS ? '288px' : isXL ? '389px' : '560px'}
                />
                {/* aicrowd large logo */}
                {!isS && (
                  <img
                    src="/assets/new_logos/landingAicrowdLogo.svg"
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
            <section className={cx(challengesWrapper, sectionGap)}>
              <div>
                <LandingHeaderContent
                  title="Your Solutions"
                  description={notebookDescription}
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
                    const { title, description, lastUpdated, image, author } = item;
                    return (
                      <div key={i} data-notebook={i + 1}>
                        <LandingNotebookCard
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
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingTop: '220px' }}>
              <div>
                <LandingHeaderContent
                  title="The Community"
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
                      const { title, description, comment_count, tier, image, loading, borderColor } = item;
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
                          />
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
            <section className={cx(challengesWrapper, sectionGap)}>
              <img src="/assets/new_logos/aicrowdBanner.svg" alt="aicrowd banner" width="100%"></img>
            </section>

            {/* AIcrowd Research  */}
            <section className={cx(challengesWrapper, sectionGap)}>
              <div>
                <LandingHeaderContent
                  title="Research"
                  description={[researchDescriptionPara1, <br />, <br />, researchDescriptionPara2]}
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
                <img src="/assets/new_logos/techcrunch-nethack.png"></img>
                <img src="/assets/new_logos/basalt-news.png"></img>
                <img src="/assets/new_logos/flatland.gif"></img>
                <img src="/assets/new_logos/bill-gates-tweet.png"></img>
              </div>
            </section>

            {/* Quotations */}
            <section
              className={cx(challengesWrapper, sectionGap)}
              style={{ display: 'flex', justifyContent: 'center' }}>
              <LandingCarousel {...quotes} />
              <span className={glowDecor1}></span>
              <span className={glowDecor2}></span>
            </section>

            {/* Join Our Global community  */}
            <section className={cx(challengesWrapper, sectionGap)}>
              <div>
                <LandingHeaderContent
                  title="Join our Global Community"
                  description=""
                  buttonText="Join Now"
                  descriptionWidth={isS ? '288px' : '496px'}
                />
              </div>
              {/* <LandingCommunityMap communityMap={communityMap} communityMapAvatar={communityMapAvatar} /> */}
              <div style={{ paddingTop: isS && '64px', width: '100%' }}>
                <Map communityMembersList={communityMembersList} />
              </div>
            </section>

            {/* Organizers logos section */}
            <section style={{ display: 'flex', justifyContent: 'flex-end' }} className={cx(sectionGap)}>
              <div className={organizerLogos1}>
                <img src="/assets/new_logos/partner-logo-unity.svg"></img>
                <img src="/assets/new_logos/partner-logo-uber.svg"></img>
                <img src="/assets/new_logos/partner-logo-spotify.svg"></img>
                <img src="/assets/new_logos/partner-logo-sbb.svg"></img>
                <img src="/assets/new_logos/partner-logo-openai.svg"></img>
                <img src="/assets/new_logos/partner-logo-firmenich.svg"></img>
                <img src="/assets/new_logos/partner-logo-unity.svg"></img>
                <img src="/assets/new_logos/partner-logo-uber.svg"></img>
                <img src="/assets/new_logos/partner-logo-spotify.svg"></img>
                <img src="/assets/new_logos/partner-logo-sbb.svg"></img>
              </div>
            </section>
            {/* Host a Challenge */}
            <section className={cx(challengesWrapper, sectionGap)} style={{ paddingTop: '105px' }}>
              <LandingHeaderContent
                title="Host a Challenge"
                description="Have an interesting out-of-box problem you want to solve?
Get in touch to host a customised challenge and unlock an array of exclusive features."
                buttonText="Get In Touch"
                buttonType="primary"
                descriptionWidth={isS ? '288px' : '496px'}
              />
              <div className={organizerLogos2}>
                <div
                  style={{
                    width: '100px',
                    height: '100px',
                    background: 'grey',
                    borderRadius: '50%',
                    justifySelf: 'center',
                  }}></div>
                <img src="/assets/new_logos/partner-logo-uber.svg"></img>
                <img src="/assets/new_logos/partner-logo-spotify.svg"></img>
                <img src="/assets/new_logos/partner-logo-sbb.svg"></img>
                <img src="/assets/new_logos/partner-logo-openai.svg"></img>
                <img src="/assets/new_logos/partner-logo-firmenich.svg"></img>
              </div>
            </section>
          </div>
        </main>
      </div>
    </>
  );
};

export default Landing;
