<?php
declare(strict_types=1);

namespace App\Service;

use App\Entity\Player;
use App\Repository\PlayerRepository;

class SomeApi
{
    public function __construct(private readonly PlayerRepository $playerRepository)
    {
    }

    public function returnTrue(): bool
    {
        return true;
    }

    public function savePlayer(Player $player)
    {
        $this->playerRepository->save($player, true);
    }
}