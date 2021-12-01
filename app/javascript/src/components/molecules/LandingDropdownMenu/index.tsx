import React from 'react';
import Link from 'src/components/atoms/Link';

import styles from './landingDropdownMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
import UserItem from '../notificationItem/UserItem';
import ChallengeItem from '../notificationItem/ChallengeItem';
import GenericItem from '../notificationItem/GenericItem';
const { main, socialIconWrapper } = styles;

export type LandingDropdownMenuProps = {
  menu: Array<{ name: string; link: string }>;
  showSocial?: boolean;
  top?: string;
  left?: string;
  right?: string;
  bottom?: string;
  setIsOpen?: any;
  enterMenu?: () => void;
  leaveMenu?: () => void;
  loading?: boolean;
  notificationData: any;
  isNotification: boolean;
};

const LandingDropdownMenu = ({
  menu,
  showSocial,
  top,
  left,
  right,
  bottom,
  enterMenu,
  leaveMenu,
  notificationData,
  loading,
  isNotification,
}: LandingDropdownMenuProps) => {
  let { userNotification, challengeNotification, genericNotification } = notificationData;

  return (
    <>
      <div
        className={main}
        style={{ top: top, left: left, right: right, bottom: bottom }}
        onMouseEnter={enterMenu}
        onMouseLeave={leaveMenu}>
        <ul>
          {menu?.map(item => {
            return (
              <a href={item.link} key={item.name}>
                <li>
                  <a>{item.name}</a>
                </li>
              </a>
            );
          })}
        </ul>

        {/* Show only for notification dropdown */}
        {isNotification && (
          <ul>
            {userNotification?.map((userNotification, i) => {
              const { url } = userNotification;
              return (
                <li key={i}>
                  <a href={url}>
                    <a>
                      <UserItem userNotification={userNotification} loading={loading} />
                    </a>
                  </a>
                </li>
              );
            })}

            {challengeNotification?.map((challengeNotification, i) => {
              const { url } = challengeNotification;
              return (
                <li key={i}>
                  <a href={url}>
                    <a>
                      <ChallengeItem challengeNotification={challengeNotification} loading={loading} />
                    </a>
                  </a>
                </li>
              );
            })}
            {genericNotification?.map((genericNotification, i) => {
              const { url } = genericNotification;
              return (
                <li key={i}>
                  <a href={url}>
                    <a>
                      <GenericItem genericNotification={genericNotification} loading={loading} />
                    </a>
                  </a>
                </li>
              );
            })}

            <li>
              <ChallengeItem challengeNotification={challengeNotification} loading={loading} />
            </li>
          </ul>
        )}

        {showSocial && (
          <div className={socialIconWrapper}>
            <SocialButtons socialType="facebook" iconType="outline" link="https://www.facebook.com/AIcrowdHQ/" />
            <SocialButtons socialType="twitter" iconType="outline" link="https://twitter.com/AIcrowdHQ" />
            <SocialButtons socialType="linkedin" iconType="outline" link="https://www.linkedin.com/company/aicrowd" />
            <SocialButtons
              socialType="youtube"
              iconType="outline"
              link="https://www.youtube.com/channel/UCUWbe23kxbwpaAP9AlzZQbQ"
            />
            <SocialButtons socialType="discord" iconType="outline" link="https://discord.com/invite/XEa56FP" />
          </div>
        )}
      </div>
    </>
  );
};

export default LandingDropdownMenu;
