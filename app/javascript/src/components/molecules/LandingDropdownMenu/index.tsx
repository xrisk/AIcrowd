import React from 'react';
import Link from 'next/link';
import onClickOutside from 'react-onclickoutside';

import styles from './landingDropdownMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
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
};

const LandingDropdownMenu = ({
  menu,
  showSocial,
  top,
  left,
  right,
  bottom,
  setIsOpen,
  enterMenu,
  leaveMenu,
}: LandingDropdownMenuProps) => {
  // @ts-ignore
  LandingDropdownMenu.handleClickOutside = () => setIsOpen(false);

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
              <li key={item.name}>
                <Link href={item.link}>
                  <a>{item.name}</a>
                </Link>
              </li>
            );
          })}
        </ul>
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
            <SocialButtons socialType="discord" iconType="outline" link="/" />
          </div>
        )}
      </div>
    </>
  );
};

const clickOutsideConfig = {
  // @ts-ignore
  handleClickOutside: () => LandingDropdownMenu.handleClickOutside,
};

export default onClickOutside(LandingDropdownMenu, clickOutsideConfig);
