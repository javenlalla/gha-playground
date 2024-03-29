<?php
declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{
    /**
     * Convert a video to another format.
     *
     * @param  Request  $request
     *
     * @return Response
     */
    #[Route('/', 'homepage')]
    public function convertVideo(Request $request): Response
    {
        return $this->render('home/index.html.twig', [
            'sup' => 'world',
        ]);
    }
}