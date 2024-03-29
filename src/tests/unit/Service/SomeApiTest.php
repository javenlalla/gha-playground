<?php
declare(strict_types=1);

namespace App\Tests\unit\Service;

use App\Entity\Player;
use App\Repository\PlayerRepository;
use App\Service\SomeApi;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class SomeApiTest extends KernelTestCase
{
    private readonly SomeApi $someApi;

    private readonly PlayerRepository $playerRepository;

    public function setUp(): void
    {
        parent::setUp();

        self::bootKernel();
        $container = static::getContainer();

        $this->someApi = $container->get(SomeApi::class);
        $this->playerRepository = $container->get(PlayerRepository::class);
    }

    public function testBasicMethod(): void
    {
        $this->assertTrue($this->someApi->returnTrue());
    }

    /**
     * @dataProvider getTestPlayers()
     * @return void
     */
    public function testPlayerPersistence(string $firstName, string $lastName, string $emailAddress)
    {
        $existingPlayer = $this->playerRepository->findOneBy(['emailAddress' => 'onlyhope@deathstar.inc']);
        $this->assertEmpty($existingPlayer);

        $newPlayer = new Player();
        $newPlayer->setFirstName($firstName);
        $newPlayer->setLastName($lastName);
        $newPlayer->setEmailAddress($emailAddress);

        $this->someApi->savePlayer($newPlayer);

        $insertedPlayer = $this->playerRepository->findOneBy(['emailAddress' => 'onlyhope@deathstar.inc']);
        $this->assertInstanceOf(Player::class, $insertedPlayer);
        $this->assertEquals($firstName, $insertedPlayer->getFirstName());
        $this->assertEquals($lastName, $insertedPlayer->getLastName());
        $this->assertEquals($emailAddress, $insertedPlayer->getEmailAddress());
    }

    public function getTestPlayers()
    {
        return [
            [
                'firstName' => 'Darth',
                'lastName' => 'Vader',
                'emailAddress' => 'onlyhope@deathstar.inc',
            ]
        ];
    }
}