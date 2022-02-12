import React from 'react';
import Link from 'src/components/atoms/Link';

import styles from './landingDropdownMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
import GenericItem from '../notificationItem/GenericItem';
const { main, socialIconWrapper, placeholderText } = styles;

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
  let { genericNotification } = notificationData;

  // Check if hovered on notification icon & notification data is available
  const isNoNotification =
    (isNotification && !genericNotification) || (isNotification && genericNotification?.length === 0);

  return (
    <>
      <div
        className={main}
        style={{
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          width: isNoNotification && '300px',
          height: isNoNotification && '100px',
        }}
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
            {genericNotification?.map((genericNotification, i) => {
              const { url } = genericNotification;
              return (
                <a href={url || ''} key={i}>
                  <li>
                    <a>
                      <GenericItem genericNotification={genericNotification} loading={loading} />
                    </a>
                  </li>
                </a>
              );
            })}
            {isNoNotification && <div className={placeholderText}>No Notifications</div>}
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
            <SocialButtons socialType="discord" iconType="outline" link="https://discord.gg/8jb55SpVJg" />
          </div>
        )}
      </div>
    </>
  );
};

export default LandingDropdownMenu;
