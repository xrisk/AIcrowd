import React from 'react';

import SiteFooter from 'src/components/organisms/SiteFooter';
import siteFooter from 'src/components/organisms/SiteFooter/siteFooter.stories';
import partnerBarLandingStories from 'src/components/organisms/PartnerBarLanding/partnerBarLanding.stories';

import Landing from './index';
import landingChallengeCardListStories from 'src/components/organisms/LandingChallengeCardList/landingChallengeCardList.stories';
import landingStatListStories from 'src/components/organisms/LandingStatList/landingStatList.stories';
import landingNavBarStories from 'src/components/organisms/LandingNavBar/landingNavBar.stories';
import landingCommunityMap from 'src/components/organisms/LandingCommunityMap/landingCommunityMap.stories';
import landingChallengeCardStories from 'src/components/organisms/LandingChallengeCard/landingChallengeCard.stories';
import landingNotebookStories from 'src/components/molecules/LandingNotebookCard/landingNotebook.stories';
import landingSubmissionStories from 'src/components/molecules/LandingSubmissionCard/landingSubmission.stories';
import landingContributorStories from 'src/components/molecules/LandingContributorCard/landingContributor.stories';
import landingCarouselStories from 'src/components/organisms/LandingCarousel/landingCarousel.stories';
import cardBadgeStories from 'src/components/atoms/CardBadge/cardBadge.stories';

const card02 = `assets/home/card/neu ui cards-02.png`;

// This default export determines where your story goes in the story list
export default {
  title: 'Pages/Landing',
  component: Landing,
  args: {
    loading: false,
    ...partnerBarLandingStories.args,
    ...landingChallengeCardListStories.args,
    ...landingStatListStories.args,
    ...landingNavBarStories.args,
    ...landingCommunityMap.args,
    landingChallengeCard1: {
      ...landingChallengeCardStories.args,
      image: card02,
      name: 'MineRL Diamond',
      color: '#FFFFFF',
    },
    landingChallengeCard2: { ...landingChallengeCardStories.args },
    landingChallengeCard3: { ...landingChallengeCardStories.args },
    notebookCardData: [
      { ...landingNotebookStories.args },
      { ...landingNotebookStories.args },
      { ...landingNotebookStories.args },
      { ...landingNotebookStories.args },
    ],
    submissionCardData: [
      { ...landingSubmissionStories.args },
      { ...landingSubmissionStories.args },
      { ...landingSubmissionStories.args },
      { ...landingSubmissionStories.args },
    ],
    contributorCardData: [
      { ...landingContributorStories.args },
      { ...landingContributorStories.args },
      { ...landingContributorStories.args },
    ],
    quotes: { ...landingCarouselStories.args },
    ...cardBadgeStories.args,
  },
  argTypes: {
    Landing: {
      control: {
        options: [],
      },
    },
  },
};

const Template = args => {
  return (
    <>
      <Landing {...args} />
      <SiteFooter {...siteFooter.args} removeMargin={false} />
    </>
  );
};

export const landing = Template.bind({});
landing.args = {};
