import React, { useState, useCallback, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';

import AicrowdLogo from 'src/components/atoms/AicrowdLogo';
import ButtonDefault from 'src/components/atoms/Button/ButtonDefault';
import LandingDropdownMenu from 'src/components/molecules/LandingDropdownMenu';
import useMediaQuery from 'src/hooks/useMediaQuery';
import { sizes } from 'src/constants/screenSizes';
import useBoolean from '../../../hooks/useBoolean';
import useHoverDropdown from 'src/hooks/useHoverDropdown';
import styles from './landingNavBar.module.scss';
import AvatarWithTier from 'src/components/atoms/AvatarWithTier';
const {
  main,
  navMenuIcon,
  fullLogo,
  cross,
  iconWrapper,
  navLinkWrapper,
  moreText,
  loginText,
  dropdownNavItemWrapper,
  navItem,
} = styles;

export type LandingNavBarProps = {
  handleMenu: () => void;
  isMenuOpen: boolean;
  setMenu: (value: boolean) => void;
  moreMenuItem: Array<{ name: string; link: string }>;
  profileMenuItem: Array<{ name: string; link: string }>;
  challengesMenuItem: { name: string; link: string };
  communityMenuItem: Array<{ name: string; link: string }>;
  tier: number;
  image: string;
  loading: boolean;
  isLoggedIn: boolean;
};

const LandingNavBar = ({
  handleMenu,
  isMenuOpen,
  setMenu,
  moreMenuItem,
  challengesMenuItem,
  communityMenuItem,
  profileMenuItem,
  tier,
  image,
  loading,
  isLoggedIn,
}: LandingNavBarProps) => {
  const isM = useMediaQuery(sizes.medium);
  const router = useRouter();

  const { show, enterButton, leaveButton, enterMenu, leaveMenu } = useHoverDropdown();
  const { value: isDropdown, setValue: setDropdown } = useBoolean();
  const [navItemHovered, setNavItemHovered] = useState({
    hoveredOn: '',
    menuItems: [],
  });
  const { hoveredOn, menuItems } = navItemHovered;

  // handle dropdown data based on which nav item hovered on
  const handleMouseEnter = useCallback(
    menuName => {
      switch (menuName) {
        case 'profile':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: profileMenuItem,
          });
          break;
        case 'community':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: communityMenuItem,
          });
          break;
        case 'more':
          setNavItemHovered({
            hoveredOn: menuName,
            menuItems: moreMenuItem,
          });
          break;

        default:
          break;
      }
      enterButton();
    },
    [setNavItemHovered]
  );

  useEffect(() => {
    setDropdown(show);
  }, [show]);

  const isCommunityHovered = hoveredOn === 'community';
  const isMoreHovered = hoveredOn === 'more';
  const isProfileHovered = hoveredOn === 'profile';

  return (
    <>
      <div className={main}>
        <Link href="/">
          {/* Aicrowd logo*/}
          <div className={fullLogo}>
            <AicrowdLogo type="full" />
          </div>
        </Link>

        {/* Hamburger icon Show only on small screens */}
        {isM && (
          <div className={iconWrapper} onClick={handleMenu} onMouseEnter={() => setMenu(true)}>
            <div className={isMenuOpen ? cross : navMenuIcon}>
              <span></span>
              <span></span>
            </div>
          </div>
        )}

        {/* Show only on large screens */}
        {!isM && (
          <div className={navLinkWrapper}>
            {isDropdown && (
              <LandingDropdownMenu
                menu={menuItems}
                top="50px"
                left={isCommunityHovered && '129px'}
                right={isMoreHovered && isLoggedIn ? '50px' : isMoreHovered ? '250px' : isProfileHovered ? '0px' : null}
                setIsOpen={setDropdown}
                showSocial={hoveredOn === 'more'}
                enterMenu={enterMenu}
                leaveMenu={leaveMenu}
              />
            )}

            <div className={dropdownNavItemWrapper} onMouseLeave={leaveButton}>
              <div className={navItem}>
                <a href={challengesMenuItem.link}>Challenges</a>
              </div>
              <div className={navItem} onMouseEnter={() => handleMouseEnter('community')}>
                Community
              </div>
              <div className={moreText} onMouseEnter={() => handleMouseEnter('more')}>
                More
              </div>
              {isLoggedIn ? (
                <div style={{ paddingLeft: '40px' }} onMouseEnter={() => handleMouseEnter('profile')}>
                  <AvatarWithTier tier={tier} image={image} loading={loading} />
                </div>
              ) : (
                <>
                  <a href="/participants/sign_in" className={loginText}>Log in</a>
                  <a href="/participants/sign_up">
                  <ButtonDefault
                    text="Sign Up"
                    type="secondary"
                    size="large"
                    iconClass="arrow-right"
                    iconColor="#F0524D"
                    fontWeight="500"
                    fontFamily="Inter"
                    hoverBorder="1px solid #f04d7e"
                    paddingTop="8px"
                    paddingBottom="8px"
                    handleClick={() => router.push('/signup')}
                  />
                  </a>
                </>
              )}
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default LandingNavBar;
