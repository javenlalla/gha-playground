<?php
declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class UtilitiesController extends AbstractController
{
    /**
     * Convert a video to another format.
     *
     * @param  Request  $request
     *
     * @return Response
     */
    #[Route('/utilities/array-generator', 'utilities.array_generator')]
    public function convertVideo(Request $request): Response
    {
        $targetArray = [];

        for ($i = 0; $i < 1000; $i++) {
            $targetArray[] = rand(-1000,1000);
        }

        return $this->render('utilities/array_generator.html.twig', [
            'targetArray' => $targetArray,
        ]);
    }
}
